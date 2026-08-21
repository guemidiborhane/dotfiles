{ _, ... }:
{
  flake.modules.nixos.nvidia =
    { config, hardware, ... }:
    {
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
