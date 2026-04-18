{ _, ... }:
{
  flake.modules.homeManager.programs-bat =
    { _, ... }:
    {
      programs.bat = {
        enable = true;
        config.theme = "Dracula";
      };
    };
}
