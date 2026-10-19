_: {
  flake.modules.homeManager.fastfetch =
    { config, lib, ... }:
    let
      cfg = config.programs.fastfetch;
    in
    {
      programs.fastfetch = {
        enable = true;
        settings = {
          logo = {
            type = "small";
            padding = {
              top = 1;
              left = 1;
              right = 3;
            };
          };

          display.separator = " ";

          modules = [
            {
              type = "host";
              key = "󰌢 ";
              format = "{1}";
              keyColor = "green";
            }
            {
              type = "cpu";
              key = " ";
              format = "{1}";
              keyColor = "green";
            }
            {
              type = "gpu";
              key = "󰾲 ";
              format = "{2}";
              keyColor = "green";
            }
            {
              type = "memory";
              key = " ";
              keyColor = "green";
              format = "{1} / {2}";
            }
            {
              type = "kernel";
              key = " ";
              keyColor = "blue";
            }
            {
              type = "command";
              text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
              key = "󰃭 ";
              keyColor = "blue";
            }
            {
              type = "uptime";
              key = " ";
              keyColor = "blue";
            }
            {
              type = "packages";
              key = " ";
              keyColor = "blue";
            }
          ];
        };
      };

      programs.fish.functions.fish_greeting.body = /* fish */ ''
        ${lib.getExe cfg.package}
      '';
    };
}
