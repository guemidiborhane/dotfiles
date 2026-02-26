{ _, ... }:
{
  flake.homeModules.programs-foot =
    { _, ... }:
    {
      programs.foot = {
        enable = true;
        server.enable = true;
      };
    };
}
