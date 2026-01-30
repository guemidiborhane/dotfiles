{ cfg, lib, ... }:
{
  system.autoUpgrade = lib.mkIf (cfg.features.auto_update or false) {
    enable = true;
    allowReboot = cfg.features.auto_reboot or false;
    flake = "github:guemidiborhane/nix-config";
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L"
    ];
    dates = "daily";
  };
}
