{ cfg, ... }:
{
  imports = [
    ./desktop.nix
    ../modules/services/tlp.nix
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.libinput.enable = cfg.features.touchpad;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  programs.light.enable = cfg.features.backlight;
}
