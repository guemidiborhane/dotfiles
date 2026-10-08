{ _, ... }:
{
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
