#!/usr/bin/env python3
"""
hypres — Hyprland session save & restore
Inspired by i3-resurrect. Works around Wayland's geometry negotiation model
by using Hyprland's IPC socket2 for precise window tracking.

Usage:
  hypres save              # snapshot current session
  hypres restore           # restore last saved session
  hypres restore --dry-run # show what would happen
  hypres info              # print saved session summary
  hypres status            # show running vs saved diff
"""

import json
import subprocess
import time
import socket
import os
import sys
import argparse
import datetime
from pathlib import Path
from collections import defaultdict
from typing import Optional

try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib  # type: ignore
    except ImportError:
        tomllib = None  # type: ignore

_XDG_STATE  = Path(os.environ.get("XDG_STATE_HOME",  Path.home() / ".local/state"))
_XDG_CONFIG = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))

STATE_DIR     = _XDG_STATE  / "hypres"
CONFIG_DIR    = _XDG_CONFIG / "hypres"
SESSION_FILE  = STATE_DIR   / "session.json"
COMMANDS_TOML = CONFIG_DIR  / "commands.toml"
COMMANDS_JSON = CONFIG_DIR  / "commands.json"   # fallback if no tomllib

WINDOW_TIMEOUT    = float(os.environ.get("HYPRES_WINDOW_TIMEOUT",   "12.0"))
INTER_LAUNCH_GAP  = float(os.environ.get("HYPRES_INTER_LAUNCH_GAP", "0.4"))
POST_WINDOW_GRACE = float(os.environ.get("HYPRES_POST_GRACE",       "0.12"))

def _hyprctl_raw(args: list[str]) -> str:
    result = subprocess.run(["hyprctl"] + args, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"hyprctl {' '.join(args)} failed:\n{result.stderr.strip()}")
    return result.stdout

def hyprctl_json(args: list[str]) -> dict | list:
    return json.loads(_hyprctl_raw(["-j"] + args))

def hyprctl_dispatch(dsp: str, *args: str) -> None:
    args_str = ", ".join(args)
    payload = f"{dsp}({{ {args_str} }})" if args else f"{dsp}()"
    cmd = ["hyprctl", "dispatch", payload]
    subprocess.run(cmd, capture_output=True, check=False)

def get_socket2_path() -> Path:
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not sig:
        runtime = Path(f"/run/user/{os.getuid()}/hypr")
        candidates = sorted(runtime.glob("*"))
        if not candidates:
            raise RuntimeError(
                "No Hyprland instance found. "
                "Is HYPRLAND_INSTANCE_SIGNATURE set?"
            )
        sig = candidates[0].name
    xdg_runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    return Path(xdg_runtime) / "hypr" / sig / ".socket2.sock"

def _proc_cwd(pid: int) -> Optional[str]:
    """Read working directory from /proc/{pid}/cwd. Returns None if unavailable."""
    try:
        return os.readlink(f"/proc/{pid}/cwd")
    except OSError:
        return None

def save_session(quiet: bool = False) -> dict:
    STATE_DIR.mkdir(parents=True, exist_ok=True)

    clients    = hyprctl_json(["clients"])
    workspaces = hyprctl_json(["workspaces"])
    monitors   = hyprctl_json(["monitors"])

    session_clients = []
    for c in clients:
        ws_id   = c["workspace"]["id"]
        ws_name = c["workspace"]["name"]
        if ws_id == 0:                      # id 0 = unmanaged / no workspace
            continue
        if not c["class"]:                  # transient/unclassed — skip
            continue
        # Negative IDs are special workspaces (special:scratch, special:terminal …)
        is_special = ws_id < 0 or ws_name.startswith("special:")
        session_clients.append({
            "class":          c["class"],
            "initialClass":   c.get("initialClass", c["class"]),
            "title":          c["title"],
            "initialTitle":   c.get("initialTitle", c["title"]),
            "workspace_id":   ws_id,
            "workspace_name": ws_name,
            "is_special":     is_special,
            "at":             c["at"],        # [x, y]
            "size":           c["size"],      # [w, h]
            "floating":       c["floating"],
            "fullscreen":     c["fullscreen"],
            "pinned":         c.get("pinned", False),
            "monitor":        c["monitor"],
            "pid":            c["pid"],
            "cwd":            _proc_cwd(c["pid"]),
            "address":        c["address"],
        })

    # Regular workspaces first, then special workspaces. Within each group: ws id → x → y
    session_clients.sort(key=lambda c: (
        1 if c["is_special"] else 0,
        c["workspace_id"],
        c["at"][0],
        c["at"][1],
    ))

    session = {
        "version":    2,
        "timestamp":  time.time(),
        "clients":    session_clients,
        "workspaces": [
            {
                "id":      ws["id"],
                "name":    ws["name"],
                "monitor": ws["monitor"],
            }
            for ws in workspaces if ws["id"] > 0
        ],
        "monitors": [
            {
                "name":       m["name"],
                "width":      m["width"],
                "height":     m["height"],
                "x":          m["x"],
                "y":          m["y"],
                "scale":      m["scale"],
                "activeWorkspace": m.get("activeWorkspace", {}),
            }
            for m in monitors
        ],
    }

    SESSION_FILE.write_text(json.dumps(session, indent=2))
    if not quiet:
        print(f"[hypres] saved {len(session_clients)} clients → {SESSION_FILE}")
    return session

def load_commands() -> tuple[dict[str, str], dict[str, float]]:
    """
    Returns (commands, settle_times) where:
      commands     — class (lowercase) → shell command
      settle_times — class (lowercase) → seconds to collect candidate windows
                     before picking the largest (for apps with splash screens)
    """
    if COMMANDS_TOML.exists():
        if tomllib is None:
            print(
                "[hypres] WARNING: commands.toml found but tomllib is not available.\n"
                "  Either upgrade to Python 3.11+ or install tomli (pip install tomli).\n"
                f"  Falling back to {COMMANDS_JSON}",
                file=sys.stderr,
            )
        else:
            with open(COMMANDS_TOML, "rb") as f:
                data = tomllib.load(f)
            commands = {k.lower(): v for k, v in data.get("commands", {}).items()}
            settle   = {k.lower(): float(v) for k, v in data.get("settle", {}).items()}
            return commands, settle

    if COMMANDS_JSON.exists():
        data = json.loads(COMMANDS_JSON.read_text())
        commands = {k.lower(): v for k, v in data.items()}
        return commands, {}

    return {}, {}

def _collect_windows(
    sock2_path: Path,
    expected_class: str,
    collect_until: float,           # monotonic deadline
    skip_addresses: set[str],
) -> list[str]:
    """
    Drain socket2 events until collect_until, collecting every openwindow
    address matching expected_class that isn't already claimed.
    """
    found: list[str] = []
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        sock.connect(str(sock2_path))
        sock.settimeout(0.25)
        buf = b""

        while time.monotonic() < collect_until:
            try:
                chunk = sock.recv(8192)
                if not chunk:
                    break
                buf += chunk
            except TimeoutError:
                pass

            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                event = line.decode("utf-8", errors="replace").strip()
                if not event.startswith("openwindow>>"):
                    continue
                _, payload = event.split(">>", 1)
                parts = payload.split(",", 3)
                if len(parts) < 3:
                    continue
                raw_addr, _, cls = parts[0], parts[1], parts[2]
                addr = "0x" + raw_addr if not raw_addr.startswith("0x") else raw_addr
                if cls.lower() != expected_class.lower():
                    continue
                if addr not in skip_addresses and addr not in found:
                    found.append(addr)
    finally:
        sock.close()
    return found

def _largest_by_area(addresses: list[str]) -> Optional[str]:
    """
    Query hyprctl clients and return the address with the greatest pixel area.
    Falls back to the first address if none can be found in the client list.
    """
    try:
        clients = hyprctl_json(["clients"])
    except Exception:
        return addresses[0] if addresses else None

    area_map: dict[str, int] = {}
    for c in clients:
        addr = c.get("address", "")
        if not addr.startswith("0x"):
            addr = "0x" + addr
        w, h = c.get("size", [0, 0])
        area_map[addr] = w * h

    best = max(addresses, key=lambda a: area_map.get(a, 0))
    return best

def watch_for_window(
    sock2_path: Path,
    expected_class: str,
    timeout: float,
    settle_time: float = 0.0,
    skip_addresses: set[str] | None = None,
) -> Optional[str]:
    """
    Wait for an openwindow event matching expected_class.

    settle_time > 0: after the first match, keep listening for settle_time
    more seconds to catch any additional windows of the same class (splash
    screens, loading windows, etc.), then return the one with the largest
    pixel area. This handles apps like Discord/Vesktop that open a small
    transient window before the real one.

    Returns the window address (0x-prefixed) or None on timeout.
    """
    if skip_addresses is None:
        skip_addresses = set()

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        sock.connect(str(sock2_path))
        sock.settimeout(0.5)
        buf = b""
        deadline = time.monotonic() + timeout

        while time.monotonic() < deadline:
            try:
                chunk = sock.recv(8192)
                if not chunk:
                    break
                buf += chunk
            except TimeoutError:
                pass

            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                event = line.decode("utf-8", errors="replace").strip()
                if not event.startswith("openwindow>>"):
                    continue
                _, payload = event.split(">>", 1)
                parts = payload.split(",", 3)
                if len(parts) < 3:
                    continue
                raw_addr, _, cls = parts[0], parts[1], parts[2]
                addr = "0x" + raw_addr if not raw_addr.startswith("0x") else raw_addr
                if cls.lower() != expected_class.lower():
                    continue
                if addr in skip_addresses:
                    continue

                # First match found.
                if settle_time <= 0.0:
                    return addr

                # Settle mode: collect further windows on a second connection
                # for settle_time seconds, then pick the largest.
                candidates = [addr]
                settle_deadline = time.monotonic() + settle_time
                more = _collect_windows(sock2_path, expected_class, settle_deadline, skip_addresses | {addr})
                candidates.extend(more)
                return _largest_by_area(candidates)

    finally:
        sock.close()

    return None

def _apply_window_placement(addr: str, client: dict) -> None:
    """Issue hyprctl dispatches to place a window per its saved geometry."""
    ws_id      = client["workspace_id"]
    ws_name    = client["workspace_name"]
    is_special = client.get("is_special", False)
    x, y       = client["at"]
    w, h       = client["size"]
    floating   = client["floating"]
    fullscreen = client["fullscreen"]
    pinned     = client.get("pinned", False)

    # Special workspaces must be addressed by name (e.g. "special:scratch"),
    # not by their negative integer ID — Hyprland rejects the latter.
    ws_target = ws_name if is_special else str(ws_id)
    window = f"window = 'address:{addr}'"
    hyprctl_dispatch("hl.dsp.window.move", f"workspace = '{ws_target}'", window, "follow = false")

    if floating:
        hyprctl_dispatch("hl.dsp.window.float", window, "action = 'set'")
        time.sleep(0.05)
        hyprctl_dispatch("hl.dsp.window.resize", window, f"x = {w}", f"y = {h}")
        hyprctl_dispatch("hl.dsp.window.move", window, f"x = {x}", f"y = {y}")

    if pinned:
        hyprctl_dispatch("hl.dsp.pin", window)

    if fullscreen:
        hyprctl_dispatch("hl.dsp.window.fullscreen", window, "mode = 'fullscreen'", "action = 'set'")

def restore_session(dry_run: bool = False, skip_running: bool = True) -> None:
    if not SESSION_FILE.exists():
        print(
            f"[hypres] No session file at {SESSION_FILE}\n"
            "  Run 'hypres save' first.",
            file=sys.stderr,
        )
        sys.exit(1)

    session           = json.loads(SESSION_FILE.read_text())
    commands, settle  = load_commands()
    clients           = session["clients"]

    if not commands:
        print(
            f"[hypres] WARNING: no commands configured.\n"
            f"  Create {COMMANDS_TOML} — see 'hypres info' for the classes to add.",
            file=sys.stderr,
        )

    ts = datetime.datetime.fromtimestamp(session["timestamp"])
    print(f"[hypres] restoring session from {ts:%Y-%m-%d %H:%M:%S} ({len(clients)} clients)")

    if dry_run:
        print("[hypres] DRY RUN — no processes will be launched\n")

    sock2_path = get_socket2_path()
    claimed: set[str] = set()

    # Track running windows as (class_lower, workspace_id) → count.
    # A kitty on ws 1 already running only blocks the saved kitty on ws 1,
    # not the one on ws 2 or special:scratch.
    already_running: dict[tuple[str, int], int] = {}
    if skip_running and not dry_run:
        current = hyprctl_json(["clients"])
        for c in current:
            if c["workspace"]["id"] != 0:
                key = (c["class"].lower(), c["workspace"]["id"])
                already_running[key] = already_running.get(key, 0) + 1

    for idx, client in enumerate(clients):
        cls        = client["class"]
        cls_lower  = cls.lower()
        ws_id      = client["workspace_id"]
        x, y       = client["at"]
        w, h       = client["size"]
        floating   = client["floating"]
        saved_cwd  = client.get("cwd")

        cmd = commands.get(cls_lower) or commands.get(cls)
        fallback = cmd is None
        if fallback:
            cmd = cls

        # Substitute {cwd} placeholder — e.g. "footclient -D {cwd}"
        if "{cwd}" in cmd:
            if saved_cwd and Path(saved_cwd).is_dir():
                cmd = cmd.replace("{cwd}", saved_cwd)
            else:
                cmd = cmd.replace("{cwd}", str(Path.home()))

        tag = f"[{idx+1}/{len(clients)}]"

        run_key = (cls_lower, ws_id)
        if skip_running and already_running.get(run_key, 0) > 0 and not dry_run:
            already_running[run_key] -= 1
            print(f"{tag} SKIP '{cls}' ws:{ws_id} — already running (--no-skip-running to override)")
            continue

        geo_str     = f"ws:{ws_id} {'float' if floating else 'tiled':<6} {w}x{h}@{x},{y}"
        src_tag     = "(fallback)" if fallback else ""
        cls_settle  = settle.get(cls_lower, 0.0)
        settle_tag  = f"[settle:{cls_settle}s]" if cls_settle > 0 else ""
        print(f"{tag} {cls:<35} {geo_str}  {src_tag}{settle_tag}")

        if dry_run:
            src_label = "(fallback — class used as command)" if fallback else "(mapped)"
            print(f"     cmd: {cmd}  {src_label}")
            if cls_settle > 0:
                print(f"     splash filter: collect for {cls_settle}s then pick largest window")
            continue

        subprocess.Popen(
            cmd,
            shell=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )

        addr = watch_for_window(
            sock2_path,
            cls,
            WINDOW_TIMEOUT,
            settle_time=cls_settle,
            skip_addresses=claimed,
        )

        if addr is None:
            print(f"     ✗ timeout ({WINDOW_TIMEOUT}s) — window never appeared")
            continue

        claimed.add(addr)
        print(f"     ✓ window {addr}")

        time.sleep(POST_WINDOW_GRACE)
        _apply_window_placement(addr, client)

        time.sleep(INTER_LAUNCH_GAP)

    if not dry_run:
        print("[hypres] restore complete")

def cmd_info() -> None:
    if not SESSION_FILE.exists():
        print("No session saved.")
        return

    session = json.loads(SESSION_FILE.read_text())
    commands, settle = load_commands()
    ts = datetime.datetime.fromtimestamp(session["timestamp"])

    print(f"Session snapshot: {ts:%Y-%m-%d %H:%M:%S}")
    print(f"Clients: {len(session['clients'])}\n")

    ws_groups: dict[int, list] = defaultdict(list)
    for c in session["clients"]:
        ws_groups[c["workspace_id"]].append(c)

    for ws_id in sorted(ws_groups, key=lambda i: (1 if i < 0 else 0, i)):
        sample = ws_groups[ws_id][0]
        ws_label = sample["workspace_name"] if sample.get("is_special") else f"workspace {ws_id}"
        print(f"  {ws_label}:")
        for c in ws_groups[ws_id]:
            has_cmd    = "✓" if (c["class"].lower() in commands or c["class"] in commands) else "✗"
            geo        = f"{c['size'][0]}x{c['size'][1]}@{c['at'][0]},{c['at'][1]}"
            flags = " ".join(filter(None, [
                "float"      if c["floating"]   else "",
                "fullscreen" if c["fullscreen"]  else "",
                "pinned"     if c.get("pinned")  else "",
            ])) or "tiled"
            cls_settle = settle.get(c["class"].lower(), 0.0)
            settle_str = f" [settle:{cls_settle}s]" if cls_settle > 0 else ""
            print(f"    {has_cmd} {c['class']:<35} {flags:<12} {geo}{settle_str}")
    print()
    print(f"Command config: {COMMANDS_TOML}")
    missing = [
        c["class"] for c in session["clients"]
        if c["class"].lower() not in commands and c["class"] not in commands
    ]
    if missing:
        uniq_missing = sorted(set(missing))
        print("\nMissing command mappings (add to commands.toml):")
        for cls in uniq_missing:
            print(f"  \"{cls}\" = \"<launch command>\"")

def cmd_status() -> None:
    if not SESSION_FILE.exists():
        print("No session saved.")
        return

    session = json.loads(SESSION_FILE.read_text())
    current = hyprctl_json(["clients"])
    ts = datetime.datetime.fromtimestamp(session["timestamp"])

    saved_classes   = [c["class"] for c in session["clients"]]
    running_classes = [c["class"] for c in current if c["workspace"]["id"] != 0]

    saved_counts   = defaultdict(int)
    running_counts = defaultdict(int)

    for cls in saved_classes:
        saved_counts[cls] += 1
    for cls in running_classes:
        running_counts[cls] += 1

    all_classes = sorted(set(list(saved_counts) + list(running_counts)))

    print(f"Session: {ts:%Y-%m-%d %H:%M:%S}   Current: now\n")
    print(f"  {'Class':<35} {'Saved':>6} {'Running':>8}")
    print(f"  {'-'*35} {'-'*6} {'-'*8}")
    for cls in all_classes:
        s = saved_counts.get(cls, 0)
        r = running_counts.get(cls, 0)
        marker = "  " if s == r else ("+ " if r > s else "- ")
        print(f"{marker}{cls:<35} {s:>6} {r:>8}")

def main() -> None:
    parser = argparse.ArgumentParser(
        prog="hypres",
        description="Hyprland session save & restore (i3-resurrect for Wayland)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub = parser.add_subparsers(dest="command", metavar="COMMAND")

    sub.add_parser("save",   help="Snapshot current Hyprland session")
    sub.add_parser("info",   help="Print saved session details and missing mappings")
    sub.add_parser("status", help="Diff saved session against currently running clients")

    p_restore = sub.add_parser("restore", help="Restore saved session")
    p_restore.add_argument(
        "--dry-run", action="store_true",
        help="Show what would be launched without actually doing it",
    )
    p_restore.add_argument(
        "--no-skip-running", action="store_true",
        help="Launch apps even if a window of that class is already open",
    )

    args = parser.parse_args()

    match args.command:
        case "save":
            save_session()
        case "restore":
            restore_session(
                dry_run=args.dry_run,
                skip_running=not args.no_skip_running,
            )
        case "info":
            cmd_info()
        case "status":
            cmd_status()
        case _:
            parser.print_help()

if __name__ == "__main__":
    main()
