{ _, ... }:
{
  flake.modules.nixos.zram-swap =
    { _, ... }:
    {
      boot.tmp.useZram = true;

      zramSwap = {
        enable = true;
        priority = 100;
        algorithm = "zstd";
        memoryPercent = 30;
      };
    };
}
