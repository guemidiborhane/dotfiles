{ _, ... }:
{
  flake.modules.nixos.hardware-bluetooth =
    ctx@{ lib, pkgs, ... }:
    lib.mkIf (ctx.hardware.bluetooth or false) {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    };
}
