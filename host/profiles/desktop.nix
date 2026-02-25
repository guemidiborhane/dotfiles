{
  inputs,
  features,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nur.modules.nixos.default
    inputs.solaar.nixosModules.default
    ../modules/hyprland.nix
    ../modules/services/pipewire.nix
    ../modules/programs/thunar.nix
  ];

  services = {
    printing.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    solaar.enable = true;
    fprintd.enable = features.fingerprint;
  };

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = features.bluetooth;
  services.blueman.enable = features.bluetooth;

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
