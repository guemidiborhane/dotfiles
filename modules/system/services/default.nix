{ _, ... }:
{
  flake.nixosModules.default-services =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        services-openssh
        services-qbittorrent
        services-fstrim
        services-fwupd
      ];
    };
}
