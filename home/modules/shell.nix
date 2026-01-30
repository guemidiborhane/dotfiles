{ helpers, ... }:
{
  imports = [
    ./programs/fish.nix
    ./programs/sesh.nix
  ];

  programs = {
    tealdeer = helpers.enabled;
    fastfetch = helpers.enabled;
    starship = helpers.enabled;
    eza = helpers.enabled;
    zoxide = helpers.enabled;
  };

  programs.bat = import ./programs/bat.nix;
  programs.fzf = import ./programs/fzf.nix;
  programs.mise = import ./programs/mise.nix;
  programs.neovim = import ./programs/neovim.nix;
  programs.atuin = import ./programs/atuin.nix;
  programs.btop = import ./programs/btop.nix;
}
