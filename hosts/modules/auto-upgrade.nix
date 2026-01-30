{ cfg, lib, ... }:
{
  system.autoUpgrade = lib.mkIf (cfg.features.autoUpdate or false) {
    enable = cfg.features.autoUpdate or false;
    allowReboot = cfg.features.autoReboot or false;
    flake = "github:guemidiborhane/nix-config";
    flags = [
      "-L"
    ];
    dates = "daily";
  };
}
