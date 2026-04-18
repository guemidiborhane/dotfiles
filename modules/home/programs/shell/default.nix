{ self, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        programs-fish
        programs-sesh
        programs-bat
        programs-fzf
        programs-mise
        programs-atuin
        programs-btop
        programs-direnv
        services-tmux
      ];

      programs = {
        tealdeer.enable = true;
        fastfetch.enable = true;
        starship.enable = true;
        eza.enable = true;
        zoxide.enable = true;
      };

      home.packages = with pkgs; [ devenv ];
    };
}
