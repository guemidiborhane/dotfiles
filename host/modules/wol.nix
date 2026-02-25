{ features, ... }:
{
  networking.interfaces."${features.wol}".wakeOnLan.enable = true;
  networking.firewall.allowedUDPPorts = [ 9 ];
}
