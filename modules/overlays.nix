{ inputs, self, ... }:
{
  # The `packages` overlay (our custom pkgs) is generated from the per-module
  # `flake.dex.packages.<name>` specs by modules/dex/packages.nix.
  flake.overlays = {
    # This one contains whatever you want to overlay
    # You can change versions, add patches, set compilation flags, anything really.
    # https://nixos.wiki/wiki/Overlays
    modifications = final: prev: { };

    # When applied, the stable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.stable'
    nixpkgs =
      final: prev:
      let
        config = self.dex.helpers.mkNixPkgsConfig prev.stdenv.system { };
      in
      {
        unstable = import inputs.nixpkgs-unstable config;
        stable = import inputs.nixpkgs-stable config;
      };
  };
}
