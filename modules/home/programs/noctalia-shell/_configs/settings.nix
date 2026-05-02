{ config, ... }:
let
  inherit (config.programs.noctalia-shell) colors;
in
{
  programs.noctalia-shell.settings = {
    general = {
      telemetryEnabled = false;
      radiusRatio = 0.25;
      animationSpeed = 2;
      enableShadows = true;
      shadowDirection = "center";

      autoStartAuth = false;
      lockOnSuspend = true;
      lockScreenAnimations = true;
      lockScreenBlur = 0.5;
      lockScreenCountdownDuration = 10000;
      lockScreenMonitors = [ ];
      lockScreenTint = 0.25;
      passwordChars = false;
    };
    audio.preferredPlayer = "spotify";
    colorSchemes.darkMode = true;
    dock.enabled = false;
    brightness = {
      brightnessStep = 5;
      enableDdcSupport = true;
      enforceMinimum = true;
    };
    calendar.cards = [
      {
        enabled = true;
        id = "calendar-header-card";
      }
      {
        enabled = true;
        id = "calendar-month-card";
      }
      {
        enabled = true;
        id = "weather-card";
      }
    ];
    controlCenter = {
      cards = [
        {
          enabled = true;
          id = "profile-card";
        }
        {
          enabled = true;
          id = "shortcuts-card";
        }
        {
          enabled = true;
          id = "audio-card";
        }
        {
          enabled = true;
          id = "brightness-card";
        }
        {
          enabled = true;
          id = "weather-card";
        }
        {
          enabled = true;
          id = "media-sysmon-card";
        }
      ];
      diskPath = "/";
      position = "top_right";
      shortcuts = {
        left = [
          { id = "Network"; }
          { id = "Bluetooth"; }
          { id = "WallpaperSelector"; }
          { id = "NoctaliaPerformance"; }
        ];
        right = [
          { id = "AirplaneMode"; }
          { id = "KeepAwake"; }
          { id = "NightLight"; }
        ];
      };
    };
    location = {
      analogClockInCalendar = false;
      autoLocate = true;
      firstDayOfWeek = 0;
      hideWeatherCityName = true;
      hideWeatherTimezone = false;
      showCalendarEvents = true;
      showCalendarWeather = true;
      showWeekNumberInCalendar = false;
      use12hourFormat = true;
      useFahrenheit = false;
      weatherEnabled = true;
      weatherShowEffects = true;
    };
    nightLight = {
      enabled = true;
      autoSchedule = true;
      dayTemp = "6500";
      nightTemp = "3500";
    };
    notifications = {
      enabled = true;
      backgroundOpacity = 0.8;
      clearDismissed = true;
      density = "default";
      enableBatteryToast = true;
      enableKeyboardLayoutToast = false;
      enableMarkdown = false;
      enableMediaToast = false;
      location = "top_right";
      lowUrgencyDuration = 3;
      monitors = [ ];
      normalUrgencyDuration = 5;
      criticalUrgencyDuration = 15;
      overlayLayer = true;
      respectExpireTimeout = true;
      saveToHistory = {
        critical = true;
        low = true;
        normal = true;
      };
    };
    osd = {
      enabled = true;
      autoHideMs = 2000;
      backgroundOpacity = 0.75;
      enabledTypes = [
        0
        1
        2
        3
      ];
      location = "bottom";
      overlayLayer = true;
    };
    plugins = {
      autoUpdate = true;
      notifyUpdates = true;
    };
    sessionMenu = {
      countdownDuration = 10000;
      enableCountdown = true;
      largeButtonsLayout = "single-row";
      largeButtonsStyle = true;
      position = "center";
      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "O";
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "S";
        }
        {
          action = "hibernate";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "H";
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "R";
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "e";
        }
        {
          action = "shutdown";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "Shift+S";
        }
        {
          action = "rebootToUefi";
          command = "";
          countdownEnabled = true;
          enabled = false;
          keybind = "";
        }
        {
          action = "userspaceReboot";
          command = "";
          countdownEnabled = true;
          enabled = false;
          keybind = "";
        }
      ];
      showHeader = true;
      showKeybinds = true;
    };
    systemMonitor = {
      batteryCriticalThreshold = 5;
      batteryWarningThreshold = 20;
      cpuCriticalThreshold = 90;
      cpuWarningThreshold = 80;
      enableDgpuMonitoring = true;
      externalMonitor = "missioncenter";
      useCustomColors = true;
      warningColor = colors.mPrimary;
      criticalColor = colors.mError;
    };
    ui = {
      boxBorderEnabled = true;
      fontDefault = "MonaspiceAr Nerd Font Propo";
      fontFixed = "MonaspiceAr Nerd Font Mono";
      fontDefaultScale = 1;
      fontFixedScale = 1;
      panelBackgroundOpacity = 0.9;
      panelsAttachedToBar = true;
      scrollbarAlwaysVisible = true;
      settingsPanelMode = "centered";
      settingsPanelSideBarCardStyle = false;
      tooltipsEnabled = true;
      translucentWidgets = false;
    };
    noctaliaPerformance.disableWallpaper = false;
    wallpaper = {
      enabled = true;
      automationEnabled = true;
      directory = "${config.home.homeDirectory}/.wallpaper";
      fillColor = "#000000";
      fillMode = "crop";
      hideWallpaperFilenames = false;
      panelPosition = "follow_bar";
      randomIntervalSec = 21600;
      setWallpaperOnAllMonitors = true;
      skipStartupTransition = true;
      solidColor = "#1a1a2e";
      sortOrder = "name";
      transitionDuration = 500;
      transitionEdgeSmoothness = 0.05;
      transitionType = [ "fade" ];
      useOriginalImages = true;
      viewMode = "single";
      useWallhaven = true;
      wallpaperChangeMode = "random";
    };
    idle = rec {
      enabled = true;
      lockTimeout = 600;
      screenOffTimeout = lockTimeout - 30;
      suspendTimeou = lockTimeout * 3;
    };
  };
}
