{ _, ... }:
{
  flake.modules.homeManager.bat =
    { _, ... }:
    {
      programs.bat = {
        enable = true;
        config.theme = "Dracula";
      };
    };
}
