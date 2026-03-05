{ _, ... }:
{
  flake.nixosModules.zram-swap =
    { lib, features, ... }:
    lib.mkIf (features.zramSwap or false) {
      zramSwap = {
        enable = true;
        priority = 100;
        algorithm = "lz4";
        memoryPercent = 30;
      };
    };
}
