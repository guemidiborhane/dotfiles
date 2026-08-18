{ _, ... }:
{
  flake.modules.nixos.zswap =
    { lib, features, ... }:
    lib.mkIf ((features.zSwap or false) && !(features.zramSwap or false)) {
      boot = {
        zswap = {
          enable = true;
          compressor = "lzo";
          maxPoolPercent = 20;
        };
      };
    };
}
