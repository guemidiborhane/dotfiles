{ _, ... }:
{
  flake.modules.nixos.features-auto-upgrade =
    { features, lib, ... }:
    lib.mkIf (features.autoUpdate or false) {
      system.autoUpgrade = {
        enable = true;
        allowReboot = features.autoReboot or false;
        flake = "github:guemidiborhane/nix-config";
        flags = [ "-L" ];
        dates = "daily";
        randomizedDelaySec = "45min";
      };
    };
}
