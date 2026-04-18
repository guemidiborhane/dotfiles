{ _, ... }:
{
  flake.modules.homeManager.programs-yazi =
    { _, ... }:
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
      };
    };
}
