{ _, ... }:
{
  flake.modules.nixos.auto-upgrade =
    { features, ... }:
    {
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
