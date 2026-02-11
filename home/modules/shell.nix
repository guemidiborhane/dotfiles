{ ... }:
{
  imports = [
    ./programs/fish.nix
    ./programs/sesh.nix
    ./services/tmux.nix
  ];

  programs = {
    tealdeer.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    eza.enable = true;
    zoxide.enable = true;
  };

  programs.bat = import ./programs/bat.nix;
  programs.fzf = import ./programs/fzf.nix;
  programs.mise = import ./programs/mise.nix;
  programs.neovim.enable = true;
  programs.atuin = import ./programs/atuin.nix;
  programs.btop = import ./programs/btop.nix;
}
