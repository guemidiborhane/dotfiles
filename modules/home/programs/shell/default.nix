{ self, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        dex
        programs-fish
        programs-sesh
        programs-bat
        programs-fzf
        programs-mise
        programs-atuin
        programs-btop
        devenv
        services-tmux
      ];

      programs = {
        tealdeer.enable = true;
        fastfetch.enable = true;
        starship.enable = true;
        eza.enable = true;
        zoxide.enable = true;
      };
    };
}
