{
  pkgs,
  inputs,
  ...
}: {
  home-manager = enabled;
  vicinae = import ./vicinae.nix { inherit pkgs inputs; };
}
