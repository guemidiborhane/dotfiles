{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;
    lfs.enable = true;
  };
  xdg.configFile."git/config".enable = lib.mkForce false;

  programs = {
    lazygit.enable = true;
    delta = {
      enable = true;
    };
  };

  home.packages = with pkgs; [ gitflow ];
}
