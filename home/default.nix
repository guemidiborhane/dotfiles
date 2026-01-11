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
    ./modules/shell.nix
    ./modules/desktop
  ];

  home = import ./home.nix { inherit pkgs meta; };
  services = import ./modules/services { inherit pkgs lib enabled; };

  programs.ghostty = import ./modules/programs/ghostty.nix { inherit pkgs; };
  programs.yadm = import ./modules/programs/yadm.nix { };
  programs.vicinae = import ./modules/programs/vicinae.nix { inherit pkgs inputs; };
  programs.zed-editor = import ./modules/programs/zed.nix { inherit pkgs; };

  programs = {
    home-manager = enabled;
    wezterm = enabled;
    wlogout = enabled;
    mpv = enabled;
  };
}
