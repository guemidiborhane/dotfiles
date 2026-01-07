{
  pkgs,
  enabled,
  ...
}: {
    hyprpaper = enabled;
    hypridle = enabled;
    swaync = enabled;
    polkit-gnome = enabled;
    gnome-keyring = import ./gnome-keyring.nix { inherit pkgs; };
    udiskie = import ./udiskie.nix { inherit pkgs; };
}
