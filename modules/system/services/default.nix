{ self, ... }:
{
  flake.nixosModules.default-services =
    { inputs, ... }:
    {
      imports = with self.nixosModules; [
        services-openssh
        services-qbittorrent
        services-fstrim
        services-fwupd
      ];
    };
}
