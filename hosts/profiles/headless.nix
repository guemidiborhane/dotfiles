{ config, lib, pkgs, meta, ... }:
{
  services.xserver.enable = lib.mkForce false;
  programs.hyprland.enable = lib.mkForce false;

  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;

  hardware.bluetooth.enable = lib.mkForce false;
  services.blueman.enable = lib.mkForce false;

  # Automatic updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
