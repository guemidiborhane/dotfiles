{ cfg, lib, pkgs, meta, ... }:

let
  host = meta.host;
  defaults = cfg.defaults;

  # Merge defaults with host-specific overrides
  features = defaults.features // (host.features or {});
  power = defaults.power // (host.power or {});
in
{
  imports = [
    ./desktop.nix
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.tlp = import ../modules/services/tlp.nix { inherit power; };
  services.libinput.enable = features.touchpad;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  programs.light.enable = features.backlight;
}
