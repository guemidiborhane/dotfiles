{ ... }:
{
  imports = [ ./containers.nix ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = true;
  };
  programs.virt-manager.enable = true;
}
