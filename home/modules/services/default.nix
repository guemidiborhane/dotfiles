{ pkgs, h, ... }:
{
    hyprpaper = {
      enable = true;
      package = pkgs.unstable.hyprpaper;
    };
    hypridle = h.enabled;
    swaync = h.enabled;
    polkit-gnome = h.enabled;
    udiskie = import ./udiskie.nix { inherit pkgs; };
}
