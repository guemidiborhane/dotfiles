{ self, ... }:
{
  flake.nixosModules.virtualisation =
    { inputs, ... }:
    {
      imports = with self.nixosModules; [
        libvirtd
        containers
      ];
    };
}
