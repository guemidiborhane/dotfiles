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
  wolEnabled = features.wol != false && features.wol != null;
in
{
  imports = [
    # System configuration
    ./disko.nix
    ./common.nix
    ./hosts/${host.name}/hardware-configuration.nix
    ./modules/kernel.nix
    ./modules/nix.nix
    ./modules/locales.nix

    # Additional modules
    ./modules/base-devel.nix
    ./modules/disks-mount.nix
    ./modules/networking.nix
    ./modules/virtualisation
    ./modules/users.nix
    ./modules/pkgs.nix
    ./modules/services
    ./modules/programs
    ./modules/kanata.nix
    ./modules/auto-upgrade.nix
    ./profiles/${host.type}.nix
  ]
  ++ lib.optional hasHardwareModule inputs.nixos-hardware.nixosModules.${host.hardware}
  ++ lib.optional h.hasNvidia ./modules/nvidia.nix
  ++ lib.optional wolEnabled ./modules/wol.nix
  ++ lib.optional features.remoteUnlock ./modules/remote-unlock.nix;
}
