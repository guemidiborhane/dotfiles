{ _, ... }:
{
  flake.homeModules.services-udiskie =
    { _, ... }:
    {
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "always";
      };
    };
}
