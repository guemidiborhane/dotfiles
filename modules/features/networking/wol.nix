{ _, ... }:
{
  flake.modules.nixos.wol =
    { features, ... }:
    let
      inherit (features.wol) enable iface;
    in
    {
      networking.interfaces.${iface}.wakeOnLan.enable = enable;
      networking.firewall.allowedUDPPorts = [ 9 ];
    };
}
