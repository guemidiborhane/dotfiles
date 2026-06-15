{ _, ... }:
{
  flake.modules.nixos.zswap =
    {
      lib,
      pkgs,
      features,
      ...
    }:
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
