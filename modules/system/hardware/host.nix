{ self, ... }:
{
  flake-file.inputs.nixos-hardware.url = "github:NixOs/nixos-hardware/master";

  flake.nixosModules.hardware-host =
    {
      inputs,
      host,
      hardware,
      features,
      lib,
      h,
      ...
    }:
    let
      hasHardwareModule = hardware ? module && hardware.module != "";
    in
    {
      imports = [
        self.nixosModules."hardware-${host.name}"
        self.nixosModules.hardware-bluetooth
        self.nixosModules.hardware-nvidia
        self.nixosModules.hardware-disks
        self.nixosModules.hardware-fingerprint
        self.nixosModules.hardware-touchpad
        self.nixosModules.hardware-backlight
      ]
      ++ lib.optional hasHardwareModule inputs.nixos-hardware.nixosModules.${hardware.module};
    };
}
