{ _, ... }:
{
  flake.nixosModules.hardware-bluetooth =
    {
      lib,
      features,
      pkgs,
      ...
    }:
    lib.mkIf (features.bluetooth or false) {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      environment.systemPackages = [ pkgs.bluetui ];
    };
}
