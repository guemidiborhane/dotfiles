{ self, ... }:
{
  flake.modules.nixos.features =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        adguard
        auto-upgrade
        gaming
        jellyfin
        kanata
        remote-unlock
        virtualisation
        wol
        zram-swap
        zswap
      ];
    };

  flake.modules.homeManager.features =
    { _, ... }:
    {
      imports = with self.modules.homeManager; [
      ];
    };
}
