{ _, ... }:
{
  flake.nixosModules.services-fstrim =
    { _, ... }:
    {
      services.fstrim.enable = true;
    };
}
