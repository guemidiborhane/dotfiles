{ self, lib, ... }:
let
  # Packages declared by modules via `flake.dex.packages.<name> = <callPackage fn>`,
  # the way `flake.dex.apps` colocates service specs. Each value is a plain
  # callPackage-style function (`{ lib, ... }: derivation`); a package needing a
  # non-nixpkgs arg (e.g. a flake input) supplies it as a default that closes
  # over `inputs` in its own module. `flake.dex` is an open attrset, so the set
  # is read directly from self.dex.
  packages = self.dex.packages or { };
  packageNames = builtins.attrNames packages;
in
{
  # One overlay carrying every declared package, replacing the hand-written
  # `flake.overlays.packages`. License-agnostic: `final` is the consumer's
  # nixpkgs, so unfree deps are governed by the consumer's own allowUnfree.
  flake.overlays.packages =
    final: _prev: lib.mapAttrs (_: fn: final.callPackage fn { }) packages;

  # `nix build .#<name>` outputs, built with *our* nixpkgs (our overlays +
  # unfree allowlist), mirroring the old central packages.nix.
  perSystem =
    { system, ... }:
    let
      pkgs = self.dex.helpers.mkPkgs system;
    in
    {
      packages = lib.genAttrs packageNames (name: pkgs.${name});
    };
}
