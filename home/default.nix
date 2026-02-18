{ cfg, ... }:
{
  imports = [
    ./home.nix
    ./pkgs.nix
    ./modules/git.nix
    ./modules/yadm.nix
    ./modules/shell.nix
    ./modules/programs/yadm.nix
    ./profiles/${cfg.host.type}.nix
  ];

  programs.yazi.enable = true;
  programs.home-manager.enable = true;
}
