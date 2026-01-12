{
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    START_CHARGE_THRESH_BAT0 = 65;
    STOP_CHARGE_THRESH_BAT0 = 85;
    RESTORE_THRESHOLDS_ON_BAT = true;
  };
}
