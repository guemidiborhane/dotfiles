{ _, ... }:
{
  flake.homeModules.programs-yazi =
    { _, ... }:
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
      };
    };
}
