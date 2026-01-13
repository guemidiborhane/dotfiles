{ cfg, lib, pkgs, meta, ... }:

let
  host = meta.host;
  defaults = cfg.defaults;
  features = defaults.features // (host.features or {});
in
{
  # Desktop-specific settings
  hardware.bluetooth.enable = features.bluetooth;

  # Performance governor
  powerManagement.cpuFreqGovernor = "performance";

  # Disable power saving features
  services.tlp.enable = lib.mkForce false;
}
