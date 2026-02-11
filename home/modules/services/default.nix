{ pkgs, ... }:
{
  imports = [
    ./udiskie.nix
  ];

  services = {
    hyprpaper = {
      enable = true;
      package = pkgs.unstable.hyprpaper;
    };
    hypridle.enable = true;
    swaync.enable = true;
    polkit-gnome.enable = true;
  };
}
