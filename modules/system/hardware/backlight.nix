{ _, ... }:
{
  flake.nixosModules.hardware-backlight =
    { lib, hardware, ... }:
    lib.mkIf (hardware.backlight or false) {
      hardware.acpilight.enable = true;
    };
}
