{ cfg, lib, pkgs, meta, ... }:

let
  host = meta.host;
  defaults = cfg.defaults;

  # Merge defaults with host-specific overrides
  features = defaults.features // (host.features or {});
  power = defaults.power // (host.power or {});
in
{
  # Laptop-specific settings
  hardware.bluetooth.enable = features.bluetooth;

  services.blueman.enable = features.bluetooth;

  # TLP power management
  services.tlp = lib.mkIf power.tlp {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = power.startChargeThreshold;
      STOP_CHARGE_THRESH_BAT0 = power.stopChargeThreshold;
      RESTORE_THRESHOLDS_ON_BAT = true;
    };
  };

  # Backlight control
  programs.light.enable = features.backlight;

  # Touchpad
  services.libinput.enable = features.touchpad;
}
