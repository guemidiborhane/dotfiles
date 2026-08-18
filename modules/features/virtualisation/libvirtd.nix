{ lib, ... }:
{
  flake.modules.nixos.libvirtd =
    { features, ... }:
    lib.mkIf (features.libvirtd or false) {

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      programs.virt-manager.enable = true;
    };
}
