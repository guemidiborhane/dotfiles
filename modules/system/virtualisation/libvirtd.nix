{ _, ... }:
{
  flake.nixosModules.libvirtd =
    { _, ... }:
    {

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      programs.virt-manager.enable = true;
    };
}
