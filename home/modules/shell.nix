{ h, ... }:
{
  imports = [
    ./programs/fish.nix
    ./programs/sesh.nix
  ];

  programs = {
    tealdeer = h.enabled;
    fastfetch = h.enabled;
    starship = h.enabled;
    eza = h.enabled;
    zoxide = h.enabled;
  };

  programs.bat = import ./programs/bat.nix;
  programs.fzf = import ./programs/fzf.nix;
  programs.mise = import ./programs/mise.nix;
  programs.neovim = import ./programs/neovim.nix;
  programs.atuin = import ./programs/atuin.nix;
  programs.btop = import ./programs/btop.nix;
}
