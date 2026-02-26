{ _, ... }:
{
  flake.homeModules.services-gnome-polkit =
    { _, ... }:
    {
      services.polkit-gnome.enable = true;
    };
}
