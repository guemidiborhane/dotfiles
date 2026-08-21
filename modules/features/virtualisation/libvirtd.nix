{ _, ... }:
{
  flake.modules.nixos.libvirtd =
    { ... }:
    {

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      programs.virt-manager.enable = true;
    };
}
