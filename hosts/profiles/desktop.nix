{ cfg, lib, pkgs, meta, ... }:

let
  host = meta.host;
  defaults = cfg.defaults;
  features = defaults.features // (host.features or {});
in
{
  hardware.bluetooth.enable = features.bluetooth;

  powerManagement.cpuFreqGovernor = "performance";

  services.tlp.enable = lib.mkForce false;
}
