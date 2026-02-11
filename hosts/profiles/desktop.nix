{
  cfg,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/hyprland.nix
    ../modules/services/pipewire.nix
    ../modules/programs/thunar.nix
  ];

  services = {
    printing.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    solaar.enable = true;
    fprintd.enable = cfg.features.fingerprint;
  };

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = cfg.features.bluetooth;
  services.blueman.enable = cfg.features.bluetooth;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  programs = {
    localsend.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
  ];

  fonts.packages = with pkgs; [
    cantarell-fonts
    nerd-fonts.monaspace
    nerd-fonts.jetbrains-mono
    corefonts
    vista-fonts
  ];
}
