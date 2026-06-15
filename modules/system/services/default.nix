{ self, ... }:
{
  flake.modules.nixos.default-services =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        openssh
        fstrim
        fwupd
      ];
    };
}
