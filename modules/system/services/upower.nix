{ _, ... }:
{
  flake.modules.nixos.services-upower =
    { _, ... }:
    {
      services.upower = {
        enable = true;
        criticalPowerAction = "HybridSleep";
      };
    };
}
