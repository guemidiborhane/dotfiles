{ lib, ... }:
{
  flake.modules.nixos.libvirtd =
    { features, ... }:
    lib.mkIf (features.virtualisation.libvirtd or false) {

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
      programs.virt-manager.enable = true;
    };
}
