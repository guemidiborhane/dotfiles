{ self, ... }:
{
  flake.nixosModules.features =
    { inputs, ... }:
    {
      imports = with self.nixosModules; [
        features-auto-upgrade
        features-zram-swap
        features-zswap
        features-wol
        features-remote-unlock
        features-qbittorrent-nox
        features-kanata
      ];
    };
}
