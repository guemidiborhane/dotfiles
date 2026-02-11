{
  cfg,
  lib,
  pkgs,
  h,
  ...
}:
{
  imports = [
    ../modules/hyprland.nix
  ];

  services = {
    printing.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    solaar.enable = true;
    fprintd.enable = cfg.features.fingerprint;
    pipewire = import ../modules/services/pipewire.nix;
  };

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = cfg.features.bluetooth;
  services.blueman.enable = cfg.features.bluetooth;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  programs = {
    thunar = import ../modules/programs/thunar.nix { inherit pkgs; };
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
