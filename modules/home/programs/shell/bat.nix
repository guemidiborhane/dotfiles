{ _, ... }:
{
  flake.homeModules.programs-bat =
    { _, ... }:
    {
      programs.bat = {
        enable = true;
        config.theme = "Dracula";
      };
    };
}
