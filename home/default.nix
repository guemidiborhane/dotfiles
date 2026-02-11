{ cfg, pkgs, lib, h, inputs, ...}:
let
  isGUI = !h.isHeadless;
in {
  imports = [
    ./modules/git.nix
    ./modules/yadm.nix
    ./modules/shell.nix
  ] ++ lib.optional isGUI ./profiles/desktop.nix;

  home = import ./home.nix { inherit pkgs cfg inputs; };

  programs.yazi = h.enabled;
  programs.yadm = import ./modules/programs/yadm.nix { inherit cfg; };
  programs.home-manager = h.enabled;
}
