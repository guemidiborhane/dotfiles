{ _, ... }:
{
  flake.nixosModules.libvirtd =
    { _, ... }:
    {

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = true;
      };
      programs.virt-manager.enable = true;
    };
}
