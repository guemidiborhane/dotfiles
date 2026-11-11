# This module is purely a source of truth for what
# lives under $HOME.
#
_: {
  flake.modules.homeManager.dotfiles =
    { h, config, ... }:
    let
      scriptsPath = ".local/bin";
      wallpapersPath = "Pictures/wallpaper";

      dirUnits = [
        ".config/containers/systemd"
        ".config/qt5ct"
        scriptsPath
        wallpapersPath
      ];
    in
    {
      config = {
        dex.dotfiles = h.dotfiles.discover ./. dirUnits;

        home.sessionVariables.PATH = "$PATH:${config.home.homeDirectory}/${scriptsPath}";
        programs.noctalia.settings.wallpaper =
          let
            directory = "${config.home.homeDirectory}/${wallpapersPath}";
          in
          {
            inherit directory;
            default.path = "${directory}/wallhaven_p831kp.jpg";
          };
      };
    };
}
