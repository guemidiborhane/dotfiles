{ _, ... }:
{
  flake.modules.nixos.zswap =
    { ... }:
    {
      boot = {
        zswap = {
          enable = true;
          compressor = "lzo";
          maxPoolPercent = 20;
        };
      };
    };
}
