{ _, self, ... }:
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
      tomlConfig = read.toml ./config.toml;
      inherit (self.helpers) read utils;

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

      groups = lib.mapAttrs mkGroup rec {
        clock.members = [
          "clock"
          "mawaqit"
        ];
        status.members = [
          "power_profile"
          "audio_switcher"
          "caffeine"
          "bluetooth"
          "network"
        ]
        ++ lib.optional hardware.isLaptop "battery";
        workspaces.members = [
          "workspaces"
          "special_workspaces"
        ];
        sysmon.members = [
          "temp"
          "cpu"
          "ram"
        ];
        sysmon_tray = {
          inherit (sysmon) members;

          accordion = true;
          accordion_direction = "end";
        };
        network.members = [
          "network_rx"
          "network_tx"
        ];
      };

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
        ];
      };

      groupPrefix = "group:";
      mkBar =
        bar:
        let
          moduleLists = {
            start = bar.start or defaultBar.start;
            center = bar.center or defaultBar.center;
            end = bar.end or defaultBar.end;
          };

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
            bar.default = mkBar defaultBar // {
              monitor = lib.mapAttrs (_name: mkBar) (read.toml ./bars.toml);
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
