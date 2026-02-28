{ config, pkgs, ... }:
let
  inherit (config) metadata hosts;
in
{
  default = import ./system.nix { inherit pkgs hosts metadata; };
  mise = import ./mise.nix { inherit pkgs; };
}
