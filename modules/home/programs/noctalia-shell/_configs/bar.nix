{ config, lib, ... }:
{
  programs.noctalia-shell.settings.bar =
    let
      cfg = config.programs.noctalia-shell;
      widgets = import ./widgets {
        inherit (cfg) plugins;
      };

      defaultBar = {
        left = widgets.groups.workspaces;
        center = with widgets; [
          clock
          plugins.mawaqit
          plugins.privacy-indicator
        ];
        right = lib.flatten (
          with widgets;
          [
            monitors.system
            groups.indicators
            battery
            tray
            notifications
            controlCenter
          ]
        );
      };

      bars = {
        eDP-1 = {
          right = with widgets; [
            monitors.cpu.temp
            groups.indicators
            battery
            tray
            notifications
            controlCenter
          ];
        };
        DP-1 = {
          right = with widgets; [
            monitors.network
            plugins.latency-monitor
          ];
        };
        DP-3 = {
          right = [ ];
        };
      };
    in
    {
      position = "top";
      floating = true;
      density = "default";
      useSeparateOpacity = true;
      backgroundOpacity = 0.85;
      showCapsule = false;
      capsuleOpacity = 0.5;
      widgetSpacing = 3;
      contentPadding = 0;
      displayMode = "always_visible";
      marginHorizontal = 10;
      marginVertical = 5;
      monitors = [
        "eDP-1"
        "HDMI-A-1"
        "DP-1"
        "DP-2"
        "DP-3"
      ];
      rightClickAction = "settings";
      rightClickFollowMouse = true;
      widgets = defaultBar;
      screenOverrides = lib.mapAttrsToList (name: widgets: {
        inherit name;
        enabled = true;
        widgets = {
          left = lib.flatten (widgets.left or defaultBar.left);
          center = lib.flatten (widgets.center or defaultBar.center);
          right = lib.flatten (widgets.right or defaultBar.right);
        };
      }) bars;
    };
}
