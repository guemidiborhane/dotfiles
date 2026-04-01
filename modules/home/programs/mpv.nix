{ _, ... }:
{
  flake.homeModules.programs-mpv =
    { pkgs, ... }:
    {

      programs.mpv = {
        enable = true;
        package = pkgs.mpv.override {
          mpv-unwrapped = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
            ffmpeg = pkgs.ffmpeg-full;
          };
          scripts = with pkgs.mpvScripts; [
            uosc
            autosub
            thumbnail
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
          osd-bar = false;
          osd-duration = 1000;
          osc = "no";
          osd-on-seek = "no";
          osd-bar-w = 30;
          osd-bar-h = "0.2";
        };

        scriptOpts = {
          uosc = {
            osc-title = "\${filename}";
            osc-visibility = "never";
            osc-boxvideo = true;
          };
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
    };
}
