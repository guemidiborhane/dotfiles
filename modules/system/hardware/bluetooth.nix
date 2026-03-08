{ _, ... }:
{
  flake.nixosModules.hardware-bluetooth =
    {
      lib,
      hardware,
      pkgs,
      ...
    }:
    lib.mkIf (hardware.bluetooth or false) {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      environment.systemPackages = [ pkgs.bluetui ];
    };
}
