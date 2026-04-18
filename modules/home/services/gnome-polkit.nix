{ _, ... }:
{
  flake.modules.homeManager.services-gnome-polkit =
    { _, ... }:
    {
      services.polkit-gnome.enable = true;
    };
}
