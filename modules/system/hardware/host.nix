{ _, ... }:
{
  flake.nixosModules.hardware-host =
    {
      inputs,
      host,
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
      ]
      ++ lib.optional hasHardwareModule inputs.nixos-hardware.nixosModules.${host.hardware}
      ++ lib.optional h.hasNvidia inputs.self.nixosModules.hardware-nvidia;
    };
}
