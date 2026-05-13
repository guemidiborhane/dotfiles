{ self, ... }:
{
  flake.modules.nixos.features =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        features-auto-upgrade
        features-kanata
        features-qbittorrent-nox
        features-remote-unlock
        features-virtualisation
        features-wol
        features-zram-swap
        features-zswap
      ];
    };
}
