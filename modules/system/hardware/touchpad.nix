{ _, ... }:
{
  flake.modules.nixos.hardware-touchpad =
    { lib, hardware, ... }:
    lib.mkIf (hardware.touchpad or false) {
      services.libinput.enable = true;
    };
}
