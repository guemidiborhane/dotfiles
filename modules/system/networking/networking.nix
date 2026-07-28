{ self, ... }:
{
  flake.modules.nixos.networking =
    { host, features, ... }:
    {
      imports = with self.modules.nixos; [
        networking-netbird
        networking-resolved
      ];

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
