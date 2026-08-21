{ _, ... }:
{
  flake.modules.nixos.networking =
    { host, features, ... }:
    {
      networking = {
        hostName = host.hostname;
        firewall = {
          enable = true;
          allowedTCPPorts = features.allowTCP;
          allowedUDPPorts = features.allowUDP;
        };
        networkmanager.enable = true;
      };
    };
}
