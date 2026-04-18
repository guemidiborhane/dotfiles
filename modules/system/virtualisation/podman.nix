{ _, ... }:
{
  flake.modules.nixos.podman =
    { _, ... }:
    {
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
    };
}
