{ lib, ... }:
{
  flake.modules.nixos.podman =
    { features, ... }:
    lib.mkIf (features.virtualisation.podman or false) {
      virtualisation.oci-containers.backend = "podman";
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.extraInit = ''
        if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
          export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
        fi
      '';

      programs.fish.shellAbbrs = {
        docker = "podman";
        dc = "docker-compose";
        dcb = "docker-compose build";
        dcup = "docker-compose up";
        dcupd = "docker-compose up -d";
        dcdn = "docker-compose down";
        dce = "docker-compose exec";
        dclf = "docker-compose logs -f";
        dcps = "docker-compose ps";
      };
    };
}
