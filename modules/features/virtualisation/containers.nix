{ self, ... }:
{
  flake.modules.nixos.containers =
    { pkgs, hardware, ... }:
    {

      imports = [
        self.modules.nixos.podman
      ];
      virtualisation.containers.enable = true;
      hardware.nvidia-container-toolkit.enable = hardware.hasNvidia;

      environment.systemPackages = with pkgs.stable; [
        dive
        docker-compose
      ];
    };
}
