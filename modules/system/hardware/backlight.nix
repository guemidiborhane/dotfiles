{ _, ... }:
{
  flake.modules.nixos.hardware-backlight =
    { lib, hardware, ... }:
    lib.mkIf (hardware.backlight or false) {
      hardware.acpilight.enable = true;
    };
}
