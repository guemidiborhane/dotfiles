{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
  perSystem =
    {
      config,
      pkgs,
      final,
      ...
    }:
    {
      overlayAttrs = {
        inherit (config.packages) spotify-adblock;
      };
      packages.spotify-adblock = pkgs.callPackage ../pkgs/spotify-adblock.nix { };
    };
}
