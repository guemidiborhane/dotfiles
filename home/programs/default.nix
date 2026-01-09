{
  pkgs,
  config,
  inputs,
  enabled,
  ...
}: {
  home-manager = enabled;
  mise = enabled;
  tealdeer = enabled;
  fastfetch = enabled;
  starship = enabled;
  eza = enabled;
  zoxide = enabled;
  fzf = enabled;
  bat = enabled;
  atuin = import ./atuin.nix { };
  vicinae = import ./vicinae.nix { inherit pkgs inputs; };
  ghostty = import ./ghostty.nix { inherit pkgs; };
  wlogout = enabled;
  superfile = import ./superfile.nix { inherit pkgs config; };
  yadm = import ./yadm.nix { };
  neovim = import ./neovim.nix { };
}
