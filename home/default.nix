{
  config,
  pkgs,
  inputs,
  meta,
  ...
}: let
  enabled = { enable = true; };
in {
  imports = [
    ./modules/zen-browser.nix
  ];
  home = import ./home.nix { inherit pkgs meta; };
}
