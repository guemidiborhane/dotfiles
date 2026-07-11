{ self, ... }:
{
  flake-file.inputs.hyprland.url = "github:hyprwm/Hyprland/v0.55.1";
  flake = {
    substituters.hyprland = {
      url = "https://hyprland.cachix.org";
      key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    };

    modules.nixos.desktop-hyprland =
      { inputs, pkgs, ... }:
      {
        imports = [ inputs.hyprland.nixosModules.default ];
        programs.hyprland = {
          enable = true;
          package = pkgs.hyprland;
        };

        environment.systemPackages = with pkgs; [
          wl-clipboard
        ];
      };

    modules.homeManager.desktop-hyprland =
      {
        lib,
        config,
        inputs,
        pkgs,
        host,
        ...
      }:
      let
        cfg = config.wayland.windowManager.hyprland;
        target = "hyprland-session";
      in
      {
        imports = with self.modules.homeManager; [
          inputs.hyprland.homeManagerModules.default

          desktop-common
          noctalia

          hypower
          hypres
          hydrun
        ];

        wayland.systemd.target = "${target}.target";
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          configType = "lua";
          package = pkgs.hyprland;
          extraConfig = /* lua */ ''
            require("lua")
          '';
        };

        dex.dotfiles = {
          ".config/hypr" = {
            "lua" = ./conf;
            "xdph.conf" = ./xdph.conf;
          };
        };

        services.hypower.enabled = host.type == "laptop";

        programs.hypres = {
          enabled = true;
          saveOnSleep = true;
          saveOnLogout = true;
          commands =
            let
              tmuxSessionTerminal =
                name: "footclient --app-id '${name}-session' -e fish -c 'tmux new-session -As ${name}'";
            in
            {
              "org.telegram.desktop" = "Telegram";
              "signal" = "signal-desktop";
              "monitors-session" = tmuxSessionTerminal "monitors";
              "workshop-session" = tmuxSessionTerminal "workshop";
              "org.qbittorrent.qBittorrent" = "qbittorrent";
              "spotify" = "env -u DISPLAY spotify";
            };
        };

        home.packages = with pkgs; [ hyprpicker ];

        systemd.user.targets.${target} = {
          Unit = {
            Description = "Hyprland compositor session";
            Documentation = [ "man:systemd.special(7)" ];
            BindsTo = [ "graphical-session.target" ];
            Wants = [
              "graphical-session-pre.target"
            ];
            After = [ "graphical-session-pre.target" ];
          };
        };

        programs.fish.loginShellInit = /* fish */ ''
          if test -z "$DISPLAY" -a "$XDG_VTNR" = 1 -a -z "$SSH_CONNECTION" -a (tty | string match -r '/dev/tty[0-9]+')
              exec ${cfg.finalPackage}/bin/start-hyprland
          end
        '';
      };
  };
}
