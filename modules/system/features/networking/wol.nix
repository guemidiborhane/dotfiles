{ lib, ... }:
{
  flake.modules.nixos.features-wol =
    { features, ... }:
    let
      inherit (features.wol) enable iface;
    in
    lib.mkIf (enable && iface != "") {
      networking.interfaces.${iface}.wakeOnLan.enable = enable;
      networking.firewall.allowedUDPPorts = [ 9 ];
    };
}
