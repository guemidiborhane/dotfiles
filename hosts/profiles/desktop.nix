{ cfg, lib, pkgs, h, ... }:
{
  imports = [
    ../modules/hyprland.nix
  ];

  services = {
    printing = h.enabled;
    udisks2 = h.enabled;
    gvfs = h.enabled;
    solaar = h.enabled;
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
