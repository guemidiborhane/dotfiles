{ lib, ... }:
{
  flake.modules.nixos.hardware-nvidia =
    { config, hardware, ... }:
    lib.mkIf hardware.hasNvidia {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        graphics.enable = true;

        nvidia = {
          open = true;
          nvidiaSettings = true;
          powerManagement.enable = true;
          modesetting.enable = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };
    };
}
