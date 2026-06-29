{ self, ... }:
{
  flake.modules.nixos.common-host-configs =
    { _, ... }:
    {
      imports = with self.modules.nixos; [
        boot
        security
      ];
    };
}
