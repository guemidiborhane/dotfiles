{ _, ... }:
{
  flake.nixosModules.zswap =
    {
      lib,
      pkgs,
      features,
      ...
    }:
    lib.mkIf ((features.zSwap or false) && !(features.zramSwap or false)) {
      boot.kernelParams = [
        "zswap.enabled=1"
        "zswap.compressor=lz4"
        "zswap.max_pool_percent=30"
        "zswap.shrinker_enabled=1"
      ];
    };
}
