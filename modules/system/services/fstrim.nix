{ _, ... }:
{
  flake.modules.nixos.fstrim =
    { _, ... }:
    {
      services.fstrim.enable = true;
    };
}
