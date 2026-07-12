{ self, ... }:
{
  flake-file.inputs.nixos-hardware.url = "github:NixOs/nixos-hardware/master";

  flake.modules.nixos.host-hardware =
    {
      inputs,
      host,
      hardware,
      lib,
      ...
    }:
    let
      hasHardwareModule = hardware ? module && hardware.module != "";
    in
    {
      imports =
        with self.modules.nixos;
        [
          self.modules.nixos."hardware-${host.name}"
          hardware-bluetooth
          hardware-nvidia
          hardware-disks
          hardware-fingerprint
          hardware-touchpad
          hardware-backlight
        ]
        ++ lib.optional hasHardwareModule inputs.nixos-hardware.nixosModules.${hardware.module};
    };
}
