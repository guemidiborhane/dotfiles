{ self, ... }:
{
  flake.nixosModules.containers =
    {
      inputs,
      pkgs,
      h,
      ...
    }:
    {

      imports = [
        self.nixosModules.podman
      ];
      virtualisation.containers.enable = true;
      hardware.nvidia-container-toolkit.enable = h.hasNvidia;

      environment.systemPackages = with pkgs; [
        dive
        docker-compose
      ];
    };
}
