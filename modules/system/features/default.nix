{ _, ... }:
{
  flake.nixosModules.features =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        features-auto-upgrade
        features-zram-swap
        features-zswap
        features-wol
        features-remote-unlock
        features-qbittorrent
        features-kanata
      ];
    };
}
