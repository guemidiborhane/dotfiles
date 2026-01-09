{
  pkgs,
  meta,
  config,
  enabled,
  ...
}: {
  programs = {
    mise = enabled;
    tealdeer = enabled;
    fastfetch = enabled;
    starship = enabled;
    eza = enabled;
    zoxide = enabled;
    fzf = enabled;
    bat = enabled;
    wezterm = enabled;
  };

  programs.neovim = import ./programs/neovim.nix { };
  programs.atuin = import ./programs/atuin.nix { };
  programs.ghostty = import ./programs/ghostty.nix { inherit pkgs; };
  programs.superfile = import ./programs/superfile.nix { inherit pkgs config; };
  programs.sesh = import ./programs/sesh.nix { };
}
