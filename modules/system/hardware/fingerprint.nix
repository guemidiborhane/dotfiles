{ _, ... }:
{
  flake.nixosModules.hardware-fingerprint =
    { lib, hardware, ... }:
    lib.mkIf (hardware.fingerprint or false) {
      services.fprintd.enable = true;
    };
}
