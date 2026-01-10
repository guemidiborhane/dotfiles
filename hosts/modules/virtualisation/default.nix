{
  pkgs,
  ...
}: {
  imports = [ ./containers.nix ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false; # TODO test extensively
  };
  programs.virt-manager.enable = true;
}
