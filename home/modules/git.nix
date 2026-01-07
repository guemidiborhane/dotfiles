{ pkgs, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs = {
    lazygit.enable = true;
    delta = {
      enable = true;
    };
  };

  home.packages = with pkgs; [ gitflow ];
}
