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
        nameservers = [ "127.0.0.1:8853" ];
        firewall = {
          enable = true;
          allowedTCPPorts = features.allowTCP;
          allowedUDPPorts = features.allowUDP;
        };
        networkmanager.enable = true;
      };
    };
}
