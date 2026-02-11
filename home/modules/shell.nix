{ ... }:
{
  imports = [
    ./programs/fish.nix
    ./programs/sesh.nix
    ./services/tmux.nix
    ./programs/bat.nix
    ./programs/fzf.nix
    ./programs/mise.nix
    ./programs/atuin.nix
    ./programs/btop.nix
  ];

  programs = {
    tealdeer.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    eza.enable = true;
    zoxide.enable = true;
    neovim.enable = true;
  };
}
