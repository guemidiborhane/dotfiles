{ inputs, ... }:
let
  dex = import ./_dex { inherit inputs; };
in
{
  inherit (dex.config) systems;
  inherit (dex) perSystem;

  flake = {
    inherit (dex) overlays;
    inherit (dex) nixosConfigurations homeConfigurations;
  };
}
