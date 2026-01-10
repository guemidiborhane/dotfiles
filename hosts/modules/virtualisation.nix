{
  pkgs,
  meta,
  ...
}: {
  virtualisation.podman.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # should start on socket
    # for nvidia support use: hardware.nvidia-container-toolkit.enable
  };
  environment.systemPackages = [
    pkgs.unstable.docker-buildx
    pkgs.unstable.docker-compose
  ];
  users.users.${meta.username}.extraGroups = [ "docker" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false; # TODO test extensively
  };
  programs.virt-manager.enable = true;
}
