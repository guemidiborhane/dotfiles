{ power, ... }:
{
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    START_CHARGE_THRESH_BAT0 = power.startChargeThreshold;
    STOP_CHARGE_THRESH_BAT0 = power.stopChargeThreshold;
    RESTORE_THRESHOLDS_ON_BAT = true;
  };
}
