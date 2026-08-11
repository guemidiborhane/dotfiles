{ inputs, self, ... }:
{
  flake.overlays = {
    # This one brings our custom packages from the 'pkgs' directory
    # additions = final: _prev: import ../pkgs final.pkgs;

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
