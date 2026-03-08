{ _, ... }:
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
        inputs.self.nixosModules."hardware-${host.name}"
        inputs.self.nixosModules.hardware-bluetooth
        inputs.self.nixosModules.hardware-nvidia
        inputs.self.nixosModules.hardware-disks
        inputs.self.nixosModules.hardware-fingerprint
        inputs.self.nixosModules.hardware-touchpad
        inputs.self.nixosModules.hardware-backlight
      ]
      ++ lib.optional hasHardwareModule inputs.nixos-hardware.nixosModules.${hardware.module};
    };
}
