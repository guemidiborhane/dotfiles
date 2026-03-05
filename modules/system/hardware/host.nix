{ _, ... }:
{
  flake-file.inputs.nixos-hardware.url = "github:NixOs/nixos-hardware/master";

  flake.nixosModules.hardware-host =
    {
      inputs,
      host,
      features,
      lib,
      h,
      ...
    }:
    let
      hasHardwareModule = host ? hardware && host.hardware != "";
    in
    {
      imports = [
        inputs.self.nixosModules."hardware-${host.name}"
        inputs.self.nixosModules.hardware-bluetooth
        inputs.self.nixosModules.hardware-nvidia
        { services.fprintd.enable = features.fingerprint; }
      ]
      ++ lib.optional hasHardwareModule inputs.nixos-hardware.nixosModules.${host.hardware};
    };
}
