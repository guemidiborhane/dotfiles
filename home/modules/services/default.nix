{ pkgs, helpers, ... }:
{
    hyprpaper = {
      enable = true;
      package = pkgs.unstable.hyprpaper;
    };
    hypridle = helpers.enabled;
    swaync = helpers.enabled;
    polkit-gnome = helpers.enabled;
    udiskie = import ./udiskie.nix { inherit pkgs; };
}
