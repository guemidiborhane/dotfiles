{ _, ... }:
{
  flake.modules.homeManager.programs-git =
    {
      pkgs,
      lib,
      user,
      config,
      ...
    }:
    {
      programs = {
        git = {
          enable = true;
          package = pkgs.unstable.git;
          lfs.enable = true;
          settings = {
            user.email = user.email;
            user.name = user.fullName;
          };
        };
        lazygit.enable = true;
        delta.enable = true;
      };

      xdg.configFile."git/nix".text = lib.generators.toGitINI config.programs.git.iniContent;
      xdg.configFile."git/config".enable = lib.mkForce false;

      home.packages = with pkgs; [
        gitflow
        git-crypt
      ];
    };
}
