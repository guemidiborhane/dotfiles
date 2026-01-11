{
  pkgs,
  ...
}: {
  programs = {
    nh = import ./nh.nix { };
    neovim = import ./neovim.nix { };
    thunar = import ./thunar.nix { inherit pkgs; };
    fish = {
      enable = true;
      package = pkgs.unstable.fish;
    };
  };
}
