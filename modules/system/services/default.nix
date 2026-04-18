{ self, ... }:
{
  flake.modules.nixos.default-services =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        services-openssh
        services-fstrim
        services-fwupd
      ];
    };
}
