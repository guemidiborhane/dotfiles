{
  vpn = {
    id = "CustomButton";
    colorizeSystemIcon = "none";
    enableColorization = false;
    generalTooltipText = "";
    hideMode = "alwaysExpanded";
    icon = "cloud-network";
    ipcIdentifier = "vpn";
    leftClickExec = "vpn connect";
    leftClickUpdateText = false;
    maxTextLength = {
      horizontal = 0;
      vertical = 0;
    };
    middleClickExec = "vpn reconnect";
    middleClickUpdateText = false;
    parseJson = true;
    rightClickExec = "vpn disconnect";
    rightClickUpdateText = false;
    showExecTooltip = false;
    showIcon = true;
    showTextTooltip = true;
    textCollapse = "";
    textCommand = "~/.local/bin/vpn waybar";
    textIntervalMs = 3000;
    textStream = true;
    wheelDownExec = "";
    wheelDownUpdateText = false;
    wheelExec = "";
    wheelMode = "unified";
    wheelUpExec = "";
    wheelUpUpdateText = false;
    wheelUpdateText = false;
  };
}
