#!/bin/sh
set -euo pipefail

# Find first available battery
BATTERY=$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^BAT' | head -n1 || echo "")

if [ -z "$BATTERY" ]; then
	echo "[hyprpower] No battery found, exiting..."
	exit 0
fi

BATTERY_PATH="/sys/class/power_supply/$BATTERY"
LAST_STATE=""

hyprland_config() {
	value=$1

	hyprctl eval """
    hl.config({
      decoration = {
        blur = { enabled = $value },
        shadow = { enabled = $value}
      },
      animations = { enabled = $value }
    })
  """ || true
}

apply_profile() {
	local profile=$1
	echo "Switching to $profile profile"

	case "$profile" in
	battery)
		hyprland_config false
		noctalia-shell ipc call powerProfile enableNoctaliaPerformance || true
		noctalia-shell ipc call idleInhibitor disable || true
		;;
	ac)
		hyprland_config true
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
upower --monitor | while read -r; do
	STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")
	[[ "$STATUS" == "Discharging" ]] && STATE="battery" || STATE="ac"

	if [[ "$STATE" != "$LAST_STATE" ]]; then
		apply_profile "$STATE"
		LAST_STATE="$STATE"
	fi
done
