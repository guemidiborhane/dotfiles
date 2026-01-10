{
  pkgs,
  enabled,
  ...
}: {
    hyprpaper = {
      enable = true;
      package = pkgs.unstable.hyprpaper;
    };
    hypridle = enabled;
    swaync = enabled;
    polkit-gnome = enabled;
    gnome-keyring = import ./gnome-keyring.nix { inherit pkgs; };
    udiskie = import ./udiskie.nix { inherit pkgs; };
}
