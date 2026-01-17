{ inputs, lib, pkgs, ... }:
{
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      memtest86.enable = builtins.elem pkgs.stdenv.hostPlatform.system pkgs.memtest86plus.meta.platforms;
    };
  };

  security.rtkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults passwd_timeout=5
    Defaults insults
  '';

  # Set your time zone.
  time.timeZone = "Africa/Algiers";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  security.polkit.enable = true;

  environment.shellAliases.ls = lib.mkForce null;
}
