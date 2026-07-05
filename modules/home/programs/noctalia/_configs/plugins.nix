{
  config,
  secrets,
  ...
}:
let
  inherit (config.programs.noctalia-shell) colors settings;
in
{
  programs.noctalia-shell = {
    plugins =
      let
        url = "https://github.com/noctalia-dev/noctalia-plugins";
      in
      {
        version = 2;
        sources = [
          {
            enabled = true;
            name = "Noctalia Plugins";
            inherit url;
          }
        ];
        states = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = {
                enabled = true;
                sourceUrl = url;
              };
            })
            [
              "mawaqit"
              "privacy-indicator"
              "special-workspaces"
              "latency-monitor"
            ]
        );
      };

    pluginSettings = {
      mawaqit = {
        city = "Algiers";
        country = "DZ";
        method = 19;
        showCountdown = true;
        showNotifications = true;
        playAzan = false;
        azanFile = "azan1.mp3";
        school = 0;
        hijriDayOffset = 0;
        weekStartDay = 0;
        showElapsed = true;
        hidePrayerName = true;
        tuneFajr = 0;
        tuneDhuhr = 0;
        tuneAsr = 1;
        tuneMaghrib = 3;
        tuneIsha = 0;
        widgetIcon = "moon-stars";
        textColor = "none";
        iconColor = "none";
        activeColor = "primary";
        dynamicIcon = true;
        tune = true;
      };
      privacy-indicator = {
        hideInactive = true;
        enableToast = true;
        removeMargins = true;
        iconSpacing = 4;
        activeColor = "primary";
        inactiveColor = "none";
        micFilterRegex = "";
      };
      special-workspaces = {
        drawer = false;
        hideEmptyWorkspaces = true;
        expandDirection = "left";
        workspaces =
          map
            (ws: {
              inherit (ws) name icon;
              symbolColor = "none";
              showPill = false;
              size = 1;
              borderRadius = settings.general.radiusRatio;
              focusColor = "primary";
            })
            [
              {
                name = "workshop";
                icon = "ghost-3";
              }
              {
                name = "messaging";
                icon = "message";
              }
              {
                name = "music";
                icon = "brand-spotify";
              }
            ];
      };
      latency-monitor = {
        hosts = [
          {
            name = "Cloudflare DNS";
            address = "1.1.1.1";
          }
        ]
        ++ secrets.latency-monitor_hosts;
        intervalSeconds = 5;
        thresholdGood = 20;
        thresholdWarning = 200;
        showHostName = false;
        widgetIcon = "network";
        barHost = "Cloudflare DNS";
        colorGood = "#00ff7f";
        colorWarning = colors.mPrimary;
        colorCritical = colors.mError;
        showHostNameOnHover = true;
        animations = true;
      };
    };
  };
}
