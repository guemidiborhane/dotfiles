{ inputs, ... }:
{
  flake.overlays = {
    # This one brings our custom packages from the 'pkgs' directory
    # additions = final: _prev: import ../pkgs final.pkgs;

    # This one contains whatever you want to overlay
    # You can change versions, add patches, set compilation flags, anything really.
    # https://nixos.wiki/wiki/Overlays
    modifications = final: prev: {
      # TODO: drop once
      # https://github.com/NixOS/nixpkgs/pull/549253
      # lands on nixos-unstable
      hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
        postPatch = ''
          # Relax glaze dependency
          # FIXME: this shouldn't be needed once the upstream code will adopt it
          substituteInPlace CMakeLists.txt start/CMakeLists.txt hyprpm/CMakeLists.txt \
            --replace-fail "glaze 7...<8" "glaze"

        ''
        + (oldAttrs.postPatch or "");
      });
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
