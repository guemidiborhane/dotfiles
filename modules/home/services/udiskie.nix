{ _, ... }:
{
  flake.modules.homeManager.services-udiskie =
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
