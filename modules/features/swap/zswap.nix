_: {
  flake.modules.nixos.zswap =
    { ... }:
    {
      boot = {
        zswap = {
          enable = true;
          compressor = "zstd";
          maxPoolPercent = 20;
        };
      };
    };
}
