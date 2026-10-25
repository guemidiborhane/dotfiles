{ inputs, self, ... }:
{
  flake.overlays = {
    # Our custom packages from the 'pkgs' directory.
    #
    # This overlay is license-agnostic and distributable: `final` is the
    # *consumer's* nixpkgs, so any unfree dependency (e.g. spotify) is governed
    # by the consumer's own `config.allowUnfree`/`allowUnfreePredicate`. This
    # flake makes no license decision on a consumer's behalf.
    packages = final: _prev: {
      spotify-adblock = final.callPackage ../pkgs/spotify-adblock.nix { };
      pagespeed = final.callPackage ../pkgs/pagespeed/pagespeed.nix { };
    };

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
