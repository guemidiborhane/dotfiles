{ _, ... }:
{
  flake.modules.homeManager.kitty =
    { _, ... }:
    {
      programs.kitty = {
        enable = true;

        themeFile = "Dracula";

        font = {
          name = "JetBrainsMono Nerd Font";
          size = 12;
        };

        settings = {
          copy_on_select = false;
          confirm_os_window_close = 0;

          window_padding_width = 5;
          window_margin_width = 0;
          placement_strategy = "center";
          background_opacity = "1.0";
          hide_window_decorations = true;

          enable_audio_bell = false;

          tab_bar_edge = "bottom";
          tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
          tab_bar_style = "separator";
          tab_separator = " ";

          enabled_layouts = "splits:split_axis=vertical";
        };

        keybindings = {
          "alt+shift+enter" = "launch --cwd=current --location=hsplit";
          "ctrl+shift+enter" = "launch --cwd=current --location=vsplit";
          "ctrl+shift+comma" = "load_config_file";
          "ctrl+backspace" = "send_text all \\x17";
          "ctrl+shift+page_up" = "previous_tab";
          "ctrl+shift+page_down" = "next_tab";
        };
      };
    };
}
