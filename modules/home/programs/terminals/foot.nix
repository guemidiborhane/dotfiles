{ _, ... }:
{
  flake.modules.homeManager.foot =
    { _, ... }:
    {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:weight=Medium:size=12";
            term = "xterm-256color";
            pad = "3x3";
            # workers = 8;
            selection-target = "clipboard";
          };
          security.osc52 = "enabled";
          scrollback.lines = 100000;
          url = {
            launch = "xdg-open \${url}";
            label-letters = "sadfjklewcmpgh";
            osc8-underline = "url-mode";
          };
          cursor = {
            style = "block";
            blink = "yes";
          };
          mouse.hide-when-typing = "no";
          csd.preferred = "none";
          bell.system = "no";
          key-bindings.spawn-terminal = "none";
          environment = {
            TMUX = "''";
          };
          colors-dark = {
            background = "282a36";
            foreground = "f8f8f2";

            selection-foreground = "ffffff";
            selection-background = "44475a";
            urls = "8be9fd";

            regular0 = "21222c";
            regular1 = "ff5555";
            regular2 = "50fa7b";
            regular3 = "f1fa8c";
            regular4 = "bd93f9";
            regular5 = "ff79c6";
            regular6 = "8be9fd";
            regular7 = "f8f8f2";

            bright0 = "6272a4";
            bright1 = "ff6e6e";
            bright2 = "69ff94";
            bright3 = "ffffa5";
            bright4 = "d6acff";
            bright5 = "ff92df";
            bright6 = "a4ffff";
            bright7 = "ffffff";
          };
        };
      };
    };
}
