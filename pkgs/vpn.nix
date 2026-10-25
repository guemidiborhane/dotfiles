{
  lib,
  writeShellApplication,
  wireguard-tools,
  openvpn,
  netbird,
  iproute2,
  procps,
}:

writeShellApplication {
  name = "vpn";

  # Everything the script shells out to is put on its PATH from pkgs:
  #   wireguard-tools -> wg / wg-quick
  #   openvpn         -> openvpn
  #   netbird         -> netbird
  #   iproute2        -> ip (interface/type detection)
  #   procps          -> pgrep (OpenVPN process tracking)
  #
  # The dmenu-like launcher is intentionally NOT pinned: it is selected at
  # runtime via $DMENU_CMD (default "dmenu"), so the user can swap in rofi,
  # wofi, etc. Provide one on PATH yourself.
  runtimeInputs = [
    wireguard-tools
    openvpn
    netbird
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
}
