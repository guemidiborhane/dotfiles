{ self, ... }:
{
  flake.modules.nixos.features-virtualisation =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        libvirtd
        containers
        virtualbox
      ];
    };
}
