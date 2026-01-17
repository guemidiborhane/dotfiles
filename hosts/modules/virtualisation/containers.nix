{ config, lib, pkgs, meta, ... }:
{
  virtualisation = {
    containers.enable = true;

    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  hardware.nvidia-container-toolkit.enable = lib.mkIf (meta.host.gpu == "nvidia") true;

  environment.systemPackages = with pkgs; [
    dive
    docker-compose
  ];

  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';
}

