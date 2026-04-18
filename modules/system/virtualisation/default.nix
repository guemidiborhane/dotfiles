{ self, ... }:
{
  flake.modules.nixos.virtualisation =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        libvirtd
        containers
      ];
    };
}
