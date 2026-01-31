{ cfg, ... }:
{
  networking.interfaces."${cfg.features.wol}".wakeOnLan.enable = true;
  networking.firewall.allowedUDPPorts = [ 9 ];
}
