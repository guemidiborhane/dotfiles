{
  config,
  pkgs,
  inputs,
  meta,
  ...
}: let
  enabled = { enable = true; };
in {
  home = import ./home.nix { inherit pkgs meta; };
}
