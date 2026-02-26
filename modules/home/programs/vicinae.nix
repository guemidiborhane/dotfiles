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

  flake.homeModules.programs-vicinae =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.vicinae.homeManagerModules.default
      ];

      services.vicinae = {
        enable = true;

        systemd = {
          enable = true;
          autoStart = true;
          target = "user-graphical-session.target";
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };

        settings = {
          close_on_focus_loss = true;
          font = {
            normal = {
              family = "MonaspiceNe Nerd Font Mono";
              size = 11;
            };
          };
          theme = {
            dark = {
              name = "dracula";
              icon_theme = "Kora";
            };
          };
          launcher_window = {
            opacity = 0.95;
            client_side_decorations = {
              enabled = true;
              rounding = 5;
            };
          };
          favorites = [
            "applications:bitwarden"
            "applications:zen-beta"
            "applications:footclient"
            "applications:thunderbird"
          ];
          providers = {
            clipboard = {
              preferences = {
                encryption = true;
              };
            };
          };
        };

        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
          nix
        ];
      };
    };
}
