{ pkgs, lib, cfg, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;
    lfs.enable = true;
    settings = {
      user.email = cfg.user.email;
      user.name = cfg.user.fullName;
    };
  };
  xdg.configFile."git/nix".text = lib.generators.toGitINI config.programs.git.iniContent;
  xdg.configFile."git/config".enable = lib.mkForce false;

  programs.lazygit.enable = true;
  programs.delta.enable = true;

  home.packages = with pkgs; [ gitflow ];
}
