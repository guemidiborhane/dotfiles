{ _, ... }:
{
  flake.modules.nixos.auto-upgrade =
    { features, lib, ... }:
    lib.mkIf (features.autoUpdate or false) {
      system.autoUpgrade = {
        enable = true;
        allowReboot = features.autoReboot or false;
        flake = "github:guemidiborhane/dotfiles";
        flags = [ "-L" ];
        dates = "daily";
        randomizedDelaySec = "45min";
      };
    };
}
