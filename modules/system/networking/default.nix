{ _, ... }:
{
  flake.nixosModules.networking =
    {
      inputs,
      host,
      networking,
      ...
    }:
    {
      imports = with inputs.self.nixosModules; [
        networking-netbird
        networking-resolved
        networking-wol
        networking-remote-unlock
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
