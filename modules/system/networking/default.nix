{ self, ... }:
{
  flake.modules.nixos.networking =
    {
      inputs,
      host,
      networking,
      ...
    }:
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
          allowedTCPPorts = networking.allowTCP;
          allowedUDPPorts = networking.allowUDP;
        };
        networkmanager.enable = true;
      };
    };
}
