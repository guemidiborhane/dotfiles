{ _, ... }:
{
  flake.homeModules.shell =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        programs-fish
        programs-sesh
        programs-bat
        programs-fzf
        programs-mise
        programs-atuin
        programs-btop
        services-tmux
      ];

      programs = {
        tealdeer.enable = true;
        fastfetch.enable = true;
        starship.enable = true;
        eza.enable = true;
        zoxide.enable = true;
        neovim.enable = true;
      };
    };
}
