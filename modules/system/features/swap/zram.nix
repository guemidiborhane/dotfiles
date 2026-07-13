{ _, ... }:
{
  flake.modules.nixos.zram-swap =
    { lib, features, ... }:
    lib.mkIf ((features.zramSwap or false) && !(features.zSwap or false)) {
      zramSwap = {
        enable = true;
        priority = 100;
        algorithm = "lz4";
        memoryPercent = 30;
      };
    };
}
