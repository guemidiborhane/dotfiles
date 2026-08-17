{ self, ... }:
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
      hardware,
      pkgs,
      ...
    }:
    let
      inherit (self.helpers) read utils;

      tomlConfig = read.toml ./config.toml;
      plugins = read.toml ./plugins.toml;
      bars = read.toml ./bars.toml;
      widgets = read.toml ./widgets.toml;

      mkGroup =
        id: group:
        {
          inherit id;

          enabled = true;
          opacity = 0;
          padding = 0;
          radius = 3;
        }
        // group;

      groups = lib.mapAttrs mkGroup (
        widgets.group
        // {
          status.members = widgets.group.status.members ++ lib.optional hardware.isLaptop "battery";
          sysmon_tray = {
            inherit (widgets.group.sysmon) members;

            accordion = true;
            accordion_direction = "end";
          };
        }
      );

      mkBar =
        bar:
        let
          moduleLists = {
            start = bar.start or bars.default.start;
            center = bar.center or bars.default.center;
            end = bar.end or bars.default.end;
          };

          groupPrefix = "group:";
          groupRefs = lib.filter (lib.hasPrefix groupPrefix) (lib.flatten (lib.attrValues moduleLists));
          capsule_group = map (ref: groups."${lib.removePrefix groupPrefix ref}") groupRefs;
        in
        {
          inherit capsule_group;
          inherit (moduleLists) start center end;
        };
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        customPalettes.dracula.dark = read.json ./dracula.json;
        settings = utils.deepMerge [
          tomlConfig
          {
            plugins.enabled = plugins.enabled or [ ];
            plugin_settings = plugins.plugin_settings or { };

            widget = utils.deepMerge (
              map (arr: arr.widget or { }) [
                widgets
                plugins
              ]
            );

            bar.default = mkBar bars.default // {
              background_opacity = 0.85;
              capsule_radius = 5;
              contact_shadow = true;
              font_weight = 400;
              hover_highlight = false;
              radius = 5;
              margin_edge = 5;
              margin_ends = 10;
              padding = 10;
              widget_spacing = 10;

              monitor = lib.mapAttrs (_name: mkBar) (lib.filterAttrs (name: _value: name != "default") bars);
            };

            idle.behavior.lock-and-suspend.enabled = hardware.isLaptop;

            shell.screenshot.pipe_command = /* sh */ ''
              ${pkgs.satty}/bin/satty --filename - \
                    --output-filename "${config.home.homeDirectory}/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
                    --early-exit \
                    --actions-on-enter save-to-clipboard \
                    --actions-on-escape exit \
                    --copy-command 'wl-copy'
            '';
          }
        ];
      };
    };
}
