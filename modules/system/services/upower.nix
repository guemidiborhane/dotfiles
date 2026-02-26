{ _, ... }:
{
  flake.nixosModules.services-upower =
    { _, ... }:
    {
      services.upower = {
        enable = true;
        criticalPowerAction = "HybridSleep";
      };
    };
}
