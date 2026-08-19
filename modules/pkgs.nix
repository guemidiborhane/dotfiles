{ inputs, self, ... }:
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
    let
      nixpkgsConfig = self.dex.helpers.mkNixPkgsConfig pkgs.stdenv.system { };
      nixpkgs = import inputs.nixpkgs nixpkgsConfig;
    in
    {
      overlayAttrs = {
        inherit (config.packages) spotify-adblock;
      };

      packages.spotify-adblock = pkgs.callPackage ../pkgs/spotify-adblock.nix nixpkgs;
    };
}
