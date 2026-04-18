{ self, ... }:
{
  flake.modules.nixos.features =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
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
