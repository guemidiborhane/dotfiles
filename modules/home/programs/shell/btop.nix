{ _, ... }:
{
  flake.modules.homeManager.programs-btop =
    { _, ... }:
    {
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "dracula";
          theme_background = false;
          truecolor = false;
          force_tty = false;
          rounded_corners = false;
          vim_keys = true;
          shown_boxes = "cpu proc";
          proc_sorting = "cpu lazy";
          update_ms = 1000;
        };
      };
    };
}
