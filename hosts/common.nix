{ lib, pkgs, cfg, ... }:
{
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      memtest86.enable = builtins.elem pkgs.stdenv.hostPlatform.system pkgs.memtest86plus.meta.platforms;
    };
  };
  boot.kernel.sysctl = { "vm.swappiness" = 10; };
  zramSwap = {
    enable = cfg.features.zramSwap;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 30;
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

  imports = [ ]
    ++ lib.optional (cfg.features.wol != false && cfg.features.wol != null) ./modules/wol.nix
    ++ lib.optional cfg.features.remoteUnlock ./modules/remote-unlock.nix;
}
