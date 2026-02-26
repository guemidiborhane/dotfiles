{ _, ... }:
{
  flake.nixosModules.virtualisation =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        libvirtd
        containers
      ];
    };
}
