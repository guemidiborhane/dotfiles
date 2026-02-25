{ features, ... }:
{
  imports = [
    ./desktop.nix
    ../modules/services/tlp.nix
    ../modules/services/upower.nix
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.libinput.enable = features.touchpad;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  programs.light.enable = features.backlight;
}
