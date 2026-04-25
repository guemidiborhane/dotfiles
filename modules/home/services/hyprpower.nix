{ _, ... }:
{
  flake.modules.homeManager.services-hyprpower =
    { pkgs, config, ... }:
    let
      hyprPower = pkgs.writeShellScriptBin "hyprpower" ''
        set -euo pipefail

        # Find first available battery
        BATTERY=$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^BAT' | head -n1 || echo "")

        if [ -z "$BATTERY" ]; then
          echo "[hyprpower] No battery found, exiting..."
          exit 0
        fi

        BATTERY_PATH="/sys/class/power_supply/$BATTERY"
        LAST_STATE=""

        apply_profile() {
          local profile=$1
          echo "Switching to $profile profile"

          case "$profile" in
            battery)
              hyprctl keyword decoration:blur:enabled false || true
              hyprctl keyword decoration:shadow:enabled false || true
              hyprctl keyword animations:enabled false || true
              noctalia-shell ipc call powerProfile enableNoctaliaPerformance || true
              noctalia-shell ipc call idleInhibitor disable || true
              ;;
            ac)
              hyprctl keyword decoration:blur:enabled true || true
              hyprctl keyword decoration:shadow:enabled true || true
              hyprctl keyword animations:enabled true || true
              noctalia-shell ipc call powerProfile disableNoctaliaPerformance || true
              noctalia-shell ipc call idleInhibitor enable || true
              ;;
          esac
        }

        # Wait for Hyprland to be ready
        sleep 2

        # Apply initial profile
        STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")
        [[ "$STATUS" == "Discharging" ]] && LAST_STATE="battery" || LAST_STATE="ac"
        apply_profile "$LAST_STATE"

        # Monitor for changes
        ${pkgs.upower}/bin/upower --monitor | while read -r; do
          STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")
          [[ "$STATUS" == "Discharging" ]] && STATE="battery" || STATE="ac"

          if [[ "$STATE" != "$LAST_STATE" ]]; then
            apply_profile "$STATE"
            LAST_STATE="$STATE"
          fi
        done
      '';
    in
    {
      home.packages = [ hyprPower ];

      systemd.user.services.hyprpower = {
        Unit = {
          Description = "Hyprland power profile switcher";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${hyprPower}/bin/hyprpower";
          Restart = "on-failure";
          RestartSec = "3s";
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
