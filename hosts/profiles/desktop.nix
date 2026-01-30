{ cfg, lib, pkgs, helpers, ... }:
{
  imports = [
    ../modules/hyprland.nix
  ];

  services = {
    printing = helpers.enabled;
    udisks2 = helpers.enabled;
    gvfs = helpers.enabled;
    solaar = helpers.enabled;
    fprintd.enable = cfg.features.fingerprint;
    pipewire = import ../modules/services/pipewire.nix;
  };

  hardware.bluetooth.enable = cfg.features.bluetooth;
  services.blueman.enable = cfg.features.bluetooth;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
  ];

  fonts.packages = with pkgs; [
     cantarell-fonts
     nerd-fonts.monaspace
     nerd-fonts.jetbrains-mono
  ];
}
