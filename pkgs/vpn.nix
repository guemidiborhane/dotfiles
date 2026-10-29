{
  lib,
  symlinkJoin,
  runCommand,
  writeShellApplication,
  iproute2,
  procps,
}:

let
  vpn = writeShellApplication {
    name = "vpn";

    # Only the always-needed core utilities are pinned:
    #   iproute2 -> ip    (interface / type / IP detection; used unconditionally)
    #   procps   -> pgrep (OpenVPN process tracking)
    #
    # The VPN backends (wireguard-tools -> wg/wg-quick, openvpn, netbird) are
    # intentionally NOT pinned. Every backend call in the script is guarded by
    # `command -v`, so vpn works with whatever backends the host actually
    # installs and degrades gracefully when one is absent. A host provides the
    # backends it uses via its own systemPackages; this keeps the vpn closure
    # from dragging in all three on every host.
    #
    # The dmenu-like launcher is likewise NOT pinned: it is selected at runtime
    # via $DMENU_CMD (default "dmenu"), so the user can swap in rofi, wofi, etc.
    # Provide one on PATH yourself.
    runtimeInputs = [
      iproute2
      procps
    ];

    # writeShellApplication adds its own shebang and strict-mode header, so
    # drop the script's own shebang (ShellCheck rejects a second one).
    text = lib.removePrefix "#!/usr/bin/env sh\n" (builtins.readFile ./vpn.sh);

    meta = {
      description = "Unified VPN manager for WireGuard, OpenVPN, and Netbird with a dmenu UI";
      mainProgram = "vpn";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  # Fish completion kept inline (no separate vpn.fish file). Shipped as a
  # package vendor completion so fish auto-loads it on any host that installs
  # vpn, without touching per-user fish config.
  #
  # Completion is backed by the direct-name args: connect/disconnect/reconnect
  # accept an optional VPN name. connect offers inactive configs; disconnect and
  # reconnect offer the currently active vpns (with netbird shown as its label).
  fishCompletion = ''
    # Inactive configs (for connect): all configs minus active names.
    function __vpn_inactive
        # Build the active-name set, normalizing netbird to its label "netbird"
        # (active reports it as its interface, e.g. "wt0", but `vpn list` and the
        # connect path use the label "netbird"). Without this, an active netbird
        # would never be filtered out of the connect candidates.
        set -l active
        for aline in (vpn active 2>/dev/null)
            set -l aname (string split -f1 ':' -- $aline)
            set -l atype (string split -f2 ':' -- $aline)
            test "$atype" = netbird; and set aname netbird
            set -a active $aname
        end

        vpn list 2>/dev/null | while read -l line
            set -l name (string split -f1 ':' -- $line)
            set -l type (string split -f2 ':' -- $line)
            contains -- $name $active; and continue
            printf '%s\t%s\n' $name $type
        end
    end

    # Active vpns (for disconnect/reconnect); netbird shown as friendly label.
    function __vpn_active
        vpn active 2>/dev/null | while read -l line
            set -l name (string split -f1 ':' -- $line)
            set -l type (string split -f2 ':' -- $line)
            test "$type" = netbird; and set name netbird
            printf '%s\t%s\n' $name $type
        end
    end

    set -l cmds status list active connect c disconnect d reconnect r waybar monitor
    complete -c vpn -f
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a status         -d "Show status JSON"
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a list           -d "List configs"
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a active         -d "Show active connections"
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a "connect c"    -d "Connect"
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a "disconnect d" -d "Disconnect"
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a "reconnect r"  -d "Reconnect"
    complete -c vpn -n "not __fish_seen_subcommand_from $cmds" -a "waybar monitor" -d "Monitor mode (JSON)"

    # NAME arg: connect completes inactive; disconnect/reconnect complete active.
    complete -c vpn -n "__fish_seen_subcommand_from connect c" -f -a "(__vpn_inactive)"
    complete -c vpn -n "__fish_seen_subcommand_from disconnect d reconnect r" -f -a "(__vpn_active)"
  '';

  completion =
    runCommand "vpn-fish-completion"
      {
        inherit fishCompletion;
        passAsFile = [ "fishCompletion" ];
      }
      ''
        install -Dm644 "$fishCompletionPath" \
          "$out/share/fish/vendor_completions.d/vpn.fish"
      '';
in
symlinkJoin {
  name = "vpn";
  paths = [
    vpn
    completion
  ];
  inherit (vpn) meta;
}
