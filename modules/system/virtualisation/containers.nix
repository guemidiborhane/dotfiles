{ self, ... }:
{
  flake.modules.nixos.containers =
    {
      inputs,
      pkgs,
      h,
      ...
    }:
    {

      imports = [
        self.modules.nixos.podman
      ];
      virtualisation.containers.enable = true;
      hardware.nvidia-container-toolkit.enable = h.hasNvidia;

      environment.systemPackages = with pkgs.stable; [
        dive
        docker-compose
      ];
    };
}
