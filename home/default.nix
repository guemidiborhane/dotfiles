{ cfg, pkgs, lib, inputs, meta, helpers, ...}:
let
  isGUI = lib.elem meta.host.type [ "desktop" "laptop" ];
in {
  imports = [
    ./modules/git.nix
    ./modules/yadm.nix
    ./modules/shell.nix
    ./modules/programs/superfile.nix
  ] ++ lib.optional isGUI ./profiles/desktop.nix;

  home = import ./home.nix { inherit pkgs cfg; };

  programs.yadm = import ./modules/programs/yadm.nix { inherit cfg; };
  programs.home-manager = helpers.enabled;
}
