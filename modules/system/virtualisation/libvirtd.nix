{ _, ... }:
{
  flake.modules.nixos.libvirtd =
    { _, ... }:
    {

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      programs.virt-manager.enable = true;
    };
}
