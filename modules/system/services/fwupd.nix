{ _, ... }:
{
  flake.nixosModules.services-fwupd =
    { _, ... }:
    {
      services.fwupd.enable = true;
    };
}
