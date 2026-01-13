{ config, lib, pkgs, meta, ... }:

{
  # Headless server settings

  # No X11
  services.xserver.enable = lib.mkForce false;

  # No desktop environment
  programs.hyprland.enable = lib.mkForce false;

  # No audio
  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;

  # No bluetooth
  hardware.bluetooth.enable = lib.mkForce false;

  # Automatic updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
