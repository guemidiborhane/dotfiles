{
  config,
  pkgs,
  lib,
  inputs,
  meta,
  enabled,
  ...
}: {
  imports = [
    ./modules/zen-browser.nix
    ./modules/git.nix
    ./modules/yadm.nix
    ./modules/terminal.nix
    ./desktop
  ];

  home = import ./home.nix { inherit pkgs meta; };
  services = import ./services { inherit pkgs lib enabled; };
  programs = {
    home-manager = enabled;
    yadm = import ./modules/programs/yadm.nix { };
    vicinae = import ./modules/programs/vicinae.nix { inherit pkgs inputs; };
    wlogout = enabled;
    mpv = enabled;
    vesktop = enabled;
  };
}
