{ _, ... }:
{
  flake.modules.nixos.tlp =
    { lib, hardware, ... }:
    lib.mkIf (hardware.tlp or false) {
      services.tlp = {
        enable = true;
        settings = {
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          PLATFORM_PROFILE_ON_AC = "balanced";
          CPU_BOOST_ON_AC = 1;
          RADEON_DPM_STATE_ON_AC = "performance";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          CPU_BOOST_ON_BAT = 0;
          RADEON_DPM_STATE_ON_BAT = "battery";

          START_CHARGE_THRESH_BAT0 = hardware.startChargeThreshold;
          STOP_CHARGE_THRESH_BAT0 = hardware.stopChargeThreshold;
          RESTORE_THRESHOLDS_ON_BAT = true;
        };
      };
    };
}
