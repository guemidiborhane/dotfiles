{ self, ... }:
{
  flake.modules.nixos.features =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        auto-upgrade
        kanata
        remote-unlock
        virtualisation
        wol
        zram-swap
        zswap
        gaming
      ];
    };
}
