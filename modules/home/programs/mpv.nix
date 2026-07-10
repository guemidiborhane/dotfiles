{ _, ... }:
{
  flake.modules.homeManager.mpv =
    { pkgs, ... }:
    {

      programs.mpv = {
        enable = true;
        package = pkgs.mpv.override {
          mpv-unwrapped = pkgs.mpv-unwrapped.override {
            ffmpeg = pkgs.ffmpeg-full;
          };
          scripts = with pkgs.mpvScripts; [
            uosc
            autosub
            webtorrent-mpv-hook
            thumbfast
          ];
        };

        config = {
          hwdec = "auto";
          keep-open = true;
          save-position-on-quit = true;
          cursor-autohide = 1000;
          border = false;
          video-sync = "display-resample";
          fullscreen = true;
          screenshot-format = "png";
          title = "\${filename} - mpv";
          osc = false;
          osd-bar = false;
        };

        bindings = {
          WHEEL_UP = "add volume 5";
          WHEEL_DOWN = "add volume -5";
          UP = "add volume 5";
          DOWN = "add volume -5";
          t = "show_progress";
          v = "cycle sub";
          n = "playlist-next";
          p = "playlist-prev";
        };
      };

      xdg.desktopEntries.mpv-magnet = {
        name = "mpv (Torrent/Magnet)";
        genericName = "Torrent Streamer";
        exec = "mpv %U";
        terminal = false;
        type = "Application";
        mimeType = [ "x-scheme-handler/magnet" ];
        categories = [
          "AudioVideo"
          "Video"
          "Player"
        ];
      };
    };
}
