{ _, ... }:
{
  flake.modules.homeManager.zoxide =
    { config, ... }:
    {
      programs = {
        zoxide = {
          enable = true;
          options = [ "--cmd cd" ];
        };
      };
    };
}
