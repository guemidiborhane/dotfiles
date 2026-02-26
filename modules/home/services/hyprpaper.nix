{ _, ... }:
{
  flake.homeModules.services-hyprpaper =
    { pkgs, ... }:
    {
      services.hyprpaper = {
        enable = true;
        package = pkgs.unstable.hyprpaper;
      };
    };
}
