{ inputs, ... }:
let
  dex = import ../dex.nix { inherit inputs; };
  inherit (dex) config;
in
{
  inherit (config) systems;

  flake = {
    inherit (dex) overlays;
    inherit (dex) nixosConfigurations homeConfigurations;
  };

  perSystem =
    { pkgs, system, ... }:
    {
      formatter = pkgs.nixfmt;
      packages = import ../pkgs pkgs;
      devShells = import ../shells { inherit pkgs config; };
    };
}
