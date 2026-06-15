{ _, ... }:
{
  flake.modules.homeManager.gnome-polkit =
    { _, ... }:
    {
      services.polkit-gnome.enable = true;
    };
}
