{ cfg, ... }:
{
  enable = true;
  settings = {
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    PLATFORM_PROFILE_ON_AC = "balanced";
    CPU_BOOST_ON_AC = true;
    RADEON_DPM_STATE_ON_AC = "performance";

    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
    PLATFORM_PROFILE_ON_BAT = "low-power";
    CPU_BOOST_ON_BAT = false;
    RADEON_DPM_STATE_ON_BAT = "battery";

    START_CHARGE_THRESH_BAT0 = cfg.power.startChargeThreshold;
    STOP_CHARGE_THRESH_BAT0 = cfg.power.stopChargeThreshold;
    RESTORE_THRESHOLDS_ON_BAT = true;
  };
}
