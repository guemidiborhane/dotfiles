{ _, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell/cachix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.caches.noctalia-shell = {
    url = "https://noctalia.cachix.org";
    key = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
  };

  flake.modules.homeManager.noctalia =
    {
      inputs,
      lib,
      config,
      ...
    }:
    let
      animSpeed = 2.0;

      mkGroup = id: members: {
        inherit members id;

        enabled = true;
        opacity = 0;
        padding = 0;
        radius = 3;
      };

      groupDefs = {
        clock = [
          "clock"
          "mawaqit"
        ];
        status = [
          "audio-switcher"
          "caffeine"
          "bluetooth"
          "network"
        ];
        workspaces = [
          "workspaces"
          "special-workspaces"
        ];
        sysmon = [
          "cpu"
          "temp"
          "ram"
        ];
        network = [
          "network_rx"
          "network_tx"
        ];
      };

      groups = lib.mapAttrs mkGroup groupDefs;

      baseCapsuleGroups = [
        groups.clock
        groups.workspaces
      ];

      defaultBar = {
        start = [ "group:workspaces" ];
        center = [
          "group:clock"
          "privacy"
        ];
        end = [
          "group:sysmon"
          "group:status"
          "tray"
          "notifications"
          "control-center"
        ];
      };

      groupPrefix = "group:";
      mkBar =
        bar:
        let
          moduleLists = [
            (bar.start or [ ])
            (bar.center or [ ])
            (bar.end or [ ])
          ];
          groupRefs = lib.filter (lib.hasPrefix groupPrefix) (lib.flatten moduleLists);
          extra = map (ref: groups."${lib.removePrefix groupPrefix ref}") groupRefs;
        in
        {
          start = bar.start or defaultBar.start;
          center = bar.center or defaultBar.center;
          end = bar.end or defaultBar.end;

          capsule_group = baseCapsuleGroups ++ extra;
        };
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
        ./_dracula.nix
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          shell = {
            font_family = "MonaspiceAr Nerd Font Propo";
            screen_time_enabled = true;
            animation.speed = animSpeed;
            panel = {
              open_near_click_control_center = true;
            };
            screenshot = {
              pipe_command = /* sh */ ''
                satty --filename - \
                      --output-filename "${config.home.homeDirectory}/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
                      --early-exit \
                      --actions-on-enter save-to-clipboard \
                      --actions-on-escape exit \
                      --copy-command 'wl-copy'
              '';
              pipe_to_command = true;
              save_to_file = false;
            };
            shadow.direction = "center";
            session.actions = [
              {
                action = "lock";
                countdown_seconds = 0.0;
                enabled = true;
                shortcut = "o";
                variant = "default";
              }
              {
                action = "logout";
                countdown_seconds = 0.0;
                enabled = true;
                shortcut = "e";
                variant = "default";
              }
              {
                action = "lock_and_suspend";
                countdown_seconds = 0.0;
                enabled = true;
                shortcut = "s";
                variant = "default";
              }
              {
                action = "reboot";
                countdown_seconds = 0.0;
                enabled = true;
                shortcut = "r";
                variant = "default";
              }
              {
                action = "shutdown";
                countdown_seconds = 0.0;
                enabled = true;
                shortcut = "0";
                variant = "destructive";
              }
            ];
          };

          location.auto_locate = true;
          nightlight = {
            enabled = true;
            temperature_night = 3500;
          };
          osd.position = "bottom_center";

          lockscreen_widgets = {
            enabled = false;
            schema_version = 2;
            widget_order = [ ];
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
          };

          control_center = {
            sidebar = "full";
            shortcuts = map (type: { inherit type; }) [
              "wifi"
              "bluetooth"
              "caffeine"
              "nightlight"
              "notification"
              "mic_mute"
            ];
          };

          plugins.enabled = [
            "blackbartblues/audio-switcher"
            "nzlov/daily-wallpaper"
            "profidev/hypr-screen-mirror"
            "ycf/mawaqit"
            "jamesfeeder/special-workspaces"
            # TODO: port latency-monitor plugin
          ];

          plugin_settings = {
            "nzlov/daily-wallpaper".source = "nasa";
            "ycf/mawaqit" = {
              city = "Algiers";
              country = "DZ";
              method = "19";
              panel_placement = "attached";
              tune = true;
              tuneAsr = 1;
              tuneMaghrib = 3;
            };
          };

          wallpaper = {
            transition = [ "fade" ];
            transition_duration = 500;
          };

          widget = {
            clock.format = "%a %d · %I:%M %p";
            bluetooth.color = "secondary";
            control-center.glyph = "user-circle";
            cpu = {
              display = "text";
              label_min_width = 3;
            };
            ram.display = "text";
            temp.display = "text";
            network = {
              show_label = false;
              show_vpn_label = true;
              vpn_status = "both";
            };
            network_rx = {
              display = "text";
              show_label = false;
            };
            network_tx = {
              display = "text";
              show_label = false;
            };
            privacy.hide_inactive = true;
            tray.drawer = true;
            audio-switcher.type = "blackbartblues/audio-switcher:widget";
            hypr-screen-mirror.type = "profidev/hypr-screen-mirror:widget";
            special-workspaces = {
              type = "jamesfeeder/special-workspaces:special-workspaces";
              active_style = "ghost";
              capsule_padding = 10;
              capsule_radius = 3;
              enable_scroll = false;
              hide_inactive = true;
            };
            mawaqit = {
              type = "ycf/mawaqit:bar";
              widgetIcon = "moon-stars";
              dynamicIcon = true;
              hidePrayerName = true;
              showElapsed = true;
            };
            taskbar = {
              focused_output_only = true;
              group_by_workspace = true;
              show_active_indicator = false;
            };
            workspaces = {
              focused_output_only = true;
              max_label_chars = 2;
              scale = 1.5;
              style = "focus_hint";
            };
            battery.display_mode = "graphic";
          };

          bar.default = mkBar defaultBar // {
            background_opacity = 0.85;
            capsule_radius = 5;
            contact_shadow = true;
            font_weight = 400;
            hover_highlight = false;
            margin_edge = 5;
            margin_ends = 10;
            padding = 10;
            radius = 5;
            widget_spacing = 10;
            monitor = {
              "DP-1" = mkBar {
                end = [ "group:network" ];
              };
              "DP-3" = mkBar {
                end = [ "group:sysmon" ];
              };
              "eDP-1" = mkBar {
                end = [
                  "temp"
                  "group:status"
                  "battery"
                  "tray"
                  "notifications"
                  "hypr-screen-mirror"
                ];
              };
            };
          };
        };
      };
    };
}
