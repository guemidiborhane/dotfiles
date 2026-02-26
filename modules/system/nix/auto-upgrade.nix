{ _, ... }:
{
  flake.nixosModules.nix-auto-upgrade =
    { features, lib, ... }:
    {
      system.autoUpgrade = lib.mkIf (features.autoUpdate or false) {
        enable = features.autoUpdate or false;
        allowReboot = features.autoReboot or false;
        flake = "github:guemidiborhane/nix-config";
        flags = [
          "-L"
        ];
        dates = "daily";
        randomizedDelaySec = "45min";
      };
    };
}
