{ _, ... }:
{
  flake-file.inputs = {
    nixcord.url = "github:4evy/nixcord";
  };

  flake.modules.homeManager.discord =
    { inputs, ... }:
    {
      imports = [ inputs.nixcord.homeModules.nixcord ];

      programs.nixcord = {
        enable = true;
        discord.enable = false;
        legcord = {
          enable = true;
          equicord.enable = true;

          settings = {
            channel = "stable";
            tray = "dynamic";
            minimizeToTray = true;
            mods = [ "equicord" ];
            doneSetup = true;
          };
        };
        config = {
          frameless = true;

          enabledThemeLinks = [
            "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-catppuccin-mocha.theme.css"
          ];

          plugins = {
            hideMedia.enable = true;
            fakeNitro.enable = true;
          };
        };
      };
    };
}
