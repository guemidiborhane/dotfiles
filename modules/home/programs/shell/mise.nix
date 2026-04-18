{ _, ... }:
{
  flake.modules.homeManager.programs-mise =
    { _, ... }:
    {
      programs.mise = {
        enable = true;
      };
    };
}
