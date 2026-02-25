{ config, pkgs, ... }:
let
  inherit (config) toml hosts;
in
{
  default = import ./system.nix { inherit pkgs hosts toml; };
  mise = import ./mise.nix { inherit pkgs; };
}
