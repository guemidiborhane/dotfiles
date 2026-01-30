{ cfg, ... }:
{
  imports = [
    ./desktop.nix
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.tlp = import ../modules/services/tlp.nix { inherit cfg; };
  services.libinput.enable = cfg.features.touchpad;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  programs.light.enable = cfg.features.backlight;
}
