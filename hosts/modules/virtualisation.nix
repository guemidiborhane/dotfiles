{ pkgs, ... }: {
  virtualisation.podman.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # should start on socket
    extraPackages = with pkgs; [ docker-compose ];
    # for nvidia support use: hardwayar.nvidia-container-toolkit.enable
  };
}
