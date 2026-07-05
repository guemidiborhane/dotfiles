cfg: rec {
  groups = {
    connections = [
      network
      bluetooth
    ];
    indicators = [
      plugins.latency-monitor
      custom.vpn
      volume
      keepAwake
      groups.connections
    ];
    workspaces = [
      workspace
      plugins.special-workspaces
    ];
  };
  monitors = import ./monitors.nix;
  plugins = builtins.listToAttrs (
    map (plugin: {
      name = plugin;
      value = {
        id = "plugin:${plugin}";
      };
    }) (builtins.attrNames cfg.plugins.states)
  );
  custom = import ./custom.nix;
  volume = {
    id = "Volume";
    displayMode = "onhover";
    iconColor = "none";
    middleClickCommand = "terminal-popup 'wiremix --tab output'";
    textColor = "none";
  };
  keepAwake = {
    id = "KeepAwake";
    iconColor = "none";
    textColor = "none";
  };
  network = {
    id = "Network";
    displayMode = "onhover";
    iconColor = "none";
    textColor = "none";
  };
  bluetooth = {
    id = "Bluetooth";
    displayMode = "onhover";
    iconColor = "secondary";
    textColor = "primary";
  };
  battery = {
    id = "Battery";
    deviceNativePath = "__default__";
    displayMode = "graphic";
    hideIfIdle = false;
    hideIfNotDetected = true;
    showNoctaliaPerformance = false;
    showPowerProfiles = false;
  };
  tray = {
    id = "Tray";
    chevronColor = "none";
    colorizeIcons = false;
    drawerEnabled = true;
    hidePassive = false;
    pinned = [ "udiskie" ];
    blacklist = [ ];
  };
  notifications = {
    id = "NotificationHistory";
    hideWhenZero = false;
    hideWhenZeroUnread = false;
    iconColor = "none";
    showUnreadBadge = true;
    unreadBadgeColor = "primary";
  };
  controlCenter = {
    id = "ControlCenter";
    colorizeDistroLogo = false;
    colorizeSystemIcon = "primary";
    customIconPath = "";
    enableColorization = false;
    icon = "user-circle";
    useDistroLogo = false;
  };
  workspace = {
    id = "Workspace";
    characterCount = 2;
    colorizeIcons = false;
    emptyColor = "tertiary";
    enableScrollWheel = true;
    focusedColor = "primary";
    followFocusedScreen = false;
    fontWeight = "semibold";
    groupedBorderOpacity = 1;
    hideUnoccupied = false;
    iconScale = 0.8;
    labelMode = "index";
    occupiedColor = "secondary";
    pillSize = 0.75;
    showApplications = true;
    showApplicationsHover = false;
    showBadge = true;
    showLabelsOnlyWhenOccupied = true;
    unfocusedIconsOpacity = 0.5;
  };
  spacer = {
    id = "Spacer";
    width = 5;
  };
  clock = {
    id = "Clock";
    clockColor = "none";
    formatHorizontal = "ddd dd · h:mm AP";
    tooltipFormat = "";
    useCustomFont = false;
  };
}
