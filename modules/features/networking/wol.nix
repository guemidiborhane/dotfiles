{ lib, ... }:
{
  flake.dex.rules = [
    (
      { features, ... }:
      let
        wol = features.wol or { };
      in
      lib.optional (
        (wol.enable or false) && (wol.iface or "") == ""
      ) "features.wol.iface must be set when features.wol.enable is true."
    )
  ];

  flake.modules.nixos.wol =
    { features, ... }:
    let
      inherit (features.wol) enable iface;
    in
    {
      boot.initrd.systemd.network = {
        enable = true;
        networks."10-${iface}" = {
          matchConfig.Name = "${iface}";
          networkConfig.DHCP = "ipv4";
          # Wait until network interfaces have a routable address
          # https://wiki.archlinux.org/title/Systemd-networkd
          linkConfig.RequiredForOnline = "routable";
        };
      };
      networking.interfaces.${iface}.wakeOnLan.enable = enable;
      networking.firewall.allowedUDPPorts = [ 9 ];
    };
}
