{ _, ... }:
{
  flake.modules.nixos.upower =
    { _, ... }:
    {
      services.upower = {
        enable = true;
        criticalPowerAction = "HybridSleep";
      };
    };
}
