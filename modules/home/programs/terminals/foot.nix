{ _, ... }:
{
  flake.modules.homeManager.programs-foot =
    { _, ... }:
    {
      programs.foot = {
        enable = true;
        server.enable = true;
      };
    };
}
