{ _, ... }:
{
  flake.modules.nixos.services-fstrim =
    { _, ... }:
    {
      services.fstrim.enable = true;
    };
}
