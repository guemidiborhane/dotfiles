{ pkgs, helpers, ... }:
{
    hyprpaper = {
      enable = true;
      package = pkgs.unstable.hyprpaper;
    };
    hypridle = helpers.enabled;
    swaync = helpers.enabled;
    polkit-gnome = helpers.enabled;
    gnome-keyring = import ./gnome-keyring.nix { inherit pkgs; };
    udiskie = import ./udiskie.nix { inherit pkgs; };
}
