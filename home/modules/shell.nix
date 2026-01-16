{ pkgs, meta, config, helpers, ... }:
{
  imports = [
    ./programs/fish.nix
  ];

  programs = {
    tealdeer = helpers.enabled;
    fastfetch = helpers.enabled;
    starship = helpers.enabled;
    eza = helpers.enabled;
    zoxide = helpers.enabled;
  };

  programs.starship = import ./programs/starship.nix;
  programs.eza = import ./programs/eza.nix;
  programs.bat = import ./programs/bat.nix;
  programs.fzf = import ./programs/fzf.nix;
  programs.zoxide = import ./programs/zoxide.nix;
  programs.mise = import ./programs/mise.nix;
  programs.neovim = import ./programs/neovim.nix;
  programs.atuin = import ./programs/atuin.nix;
  programs.superfile = import ./programs/superfile.nix { inherit config; };
  programs.sesh = import ./programs/sesh.nix;
}
