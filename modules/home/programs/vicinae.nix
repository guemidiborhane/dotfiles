{ _, ... }:
{
  flake-file.inputs = {
    vicinae.url = "github:vicinaehq/vicinae";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vicinae.follows = "vicinae";
    };
  };
  flake.substituters.vicinae = {
    url = "https://vicinae.cachix.org/";
    key = "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=";
  };

  flake.modules.homeManager.vicinae =
    { inputs, pkgs, config, ... }:
    {
      imports = [
        inputs.vicinae.homeManagerModules.default
      ];

      programs.vicinae = {
        enable = true;

        systemd = {
          enable = true;
          autoStart = true;
          target = config.wayland.systemd.target;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };

        settings = {
          close_on_focus_loss = true;
          telemetry.system_info = false;

          theme = {
            dark = {
              name = "dracula";
              icon_theme = "auto";
            };
          };

          font = {
            normal = {
              family = "MonaspiceNe Nerd Font Propo";
              size = 11;
            };
          };

          favorites = [
            "applications:bitwarden"
            "applications:zen-beta"
            "applications:footclient"
            "applications:thunderbird"
          ];

          providers = {
            applications.preferences.launchPrefix = "hydrun --";
            clipboard.preferences.encryption = true;
          };

          launcher_window = {
            opacity = 0.95;
            client_side_decorations = {
              enabled = true;
              rounding = 5;
            };
          };
        };

        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
          nix
        ];
      };
    };
}
