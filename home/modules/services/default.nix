{ pkgs, h, ... }:
{
    hyprpaper = {
      enable = true;
      package = pkgs.unstable.hyprpaper;
    };
    hypridle.enable = true;
    swaync.enable = true;
    polkit-gnome.enable = true;
    udiskie = import ./udiskie.nix { inherit pkgs; };
}
