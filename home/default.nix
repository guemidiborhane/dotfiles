{
  config,
  pkgs,
  lib,
  inputs,
  meta,
  ...
}: let
  enabled = { enable = true; };
in {
  imports = [
    ./modules/zen-browser.nix
    ./desktop
  ];
  home = import ./home.nix { inherit pkgs meta; };
  services = import ./services { inherit pkgs lib enabled; };
  programs = import ./programs { inherit pkgs config inputs enabled; };
}
