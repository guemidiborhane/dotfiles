{ pkgs, ... }:
{
  programs = {
    nh = import ./nh.nix;
    neovim = import ./neovim.nix;
    fish = {
      enable = true;
      package = pkgs.unstable.fish;
    };
  };
}
