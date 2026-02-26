{ _, ... }:
{
  flake.homeModules.programs-mise =
    { _, ... }:
    {
      programs.mise = {
        enable = true;
      };
    };
}
