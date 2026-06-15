{ _, ... }:
{
  flake.modules.homeManager.udiskie =
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
