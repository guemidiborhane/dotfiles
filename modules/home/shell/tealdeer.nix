{ _, ... }:
{
  flake.modules.homeManager.tealdeer =
    { pkgs, ... }:
    {
      programs.tealdeer = {
        enable = true;
        settings.updates.auto_update_interval_hours = 720;
        enableAutoUpdates = true;
      };
    };
}
