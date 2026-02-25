{ ... }:
{
  services.upower = {
    enable = true;
    criticalPowerAction = "HybridSleep";
  };
}
