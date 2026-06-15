{ self, ... }:
{
  flake.modules.homeManager.shell =
    { config, ... }:
    {
      imports = with self.modules.homeManager; [
        dex
        programs-yadm
        git
        fish
        bat
        fzf
        mise
        atuin
        btop
        starship
        fastfetch
        eza
        yazi
        devenv
        tmux
        neovim
        tealdeer
      ];

      programs = {
        zoxide = {
          enable = true;
          options = [ "--cmd cd" ];
        };
      };
    };
}
