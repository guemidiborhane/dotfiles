{ lib, h, ... }:
let
  isGUI = !h.isHeadless;
in
{
  imports = [
    ./home.nix
    ./pkgs.nix
    ./modules/git.nix
    ./modules/yadm.nix
    ./modules/shell.nix
    ./modules/programs/yadm.nix
  ]
  ++ lib.optional isGUI ./profiles/desktop.nix;

  programs.yazi.enable = true;
  programs.home-manager.enable = true;
}
