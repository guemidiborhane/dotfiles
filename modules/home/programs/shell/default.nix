{ self, ... }:
{
  flake.modules.homeManager.shell =
    { config, ... }:
    {
      imports = with self.modules.homeManager; [
        dex
        programs-yadm
        programs-git
        programs-fish
        programs-bat
        programs-fzf
        programs-mise
        programs-atuin
        programs-btop
        programs-starship
        programs-fastfetch
        programs-eza
        programs-yazi
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
