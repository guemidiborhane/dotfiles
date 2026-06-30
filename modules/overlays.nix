{ inputs, ... }:
{
  flake.overlays = {
    # This one brings our custom packages from the 'pkgs' directory
    # additions = final: _prev: import ../pkgs final.pkgs;

    # This one contains whatever you want to overlay
    # You can change versions, add patches, set compilation flags, anything really.
    # https://nixos.wiki/wiki/Overlays
    modifications = final: prev: {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
      pnpm_10_29_2 = final.pnpm_10;
    };

    # When applied, the unstable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.unstable'
    nixpkgs =
      final: prev:
      let
        config = {
          inherit (prev.stdenv) system;
          config.allowUnfree = true;
        };
      in
      {
        unstable = import inputs.nixpkgs-unstable config;
        stable = import inputs.nixpkgs-stable config;
      };
  };
}
