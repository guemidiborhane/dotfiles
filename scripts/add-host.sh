#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$1"
NAME="$2"
SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(cd "$SCRIPTS_DIR/.." && pwd)"

cd "$REPO_ROOT"

# Check if host exists
if tomlq -e ".\"$NAME\"" "$CONFIG_FILE" >/dev/null 2>&1; then
	gum style --foreground 196 "Error: Host '$NAME' already exists"
	exit 1
fi

# Interactive inputs
gum style --foreground 212 "Host Metadata"
TYPE=$(gum choose --header "Select type:" "laptop" "desktop" "server" "headless")
DESCRIPTION=$(gum input --placeholder "Description" --value "$NAME")
HOSTNAME=$(gum input --placeholder "Short hostname (optional, press enter to skip)")
KERNEL=$(gum input --placeholder "Kernel (optional, press enter for default)")
echo

gum style --foreground 212 "Hardware Configuration"
DISK=$(gum input --placeholder "Disk device (e.g., /dev/sda, /dev/nvme0n1)" --value "/dev/sda")
RAM=$(gum input --placeholder "RAM in GB" --value "16")
CPU=$(gum choose --header "CPU vendor:" "intel" "amd")
GPU=$(gum choose --header "GPU vendor:" "intel" "amd" "nvidia" "hybrid")
HARDWARE_MODULE=$(gum input --placeholder "nixos-hardware module (optional, e.g., dell-latitude-7490)")
echo

# Hardware capabilities
gum style --foreground 212 "Hardware Capabilities"
BLUETOOTH=$(gum choose --header "Bluetooth:" "true" "false")
WIFI=$(gum choose --header "WiFi:" "true" "false")
FINGERPRINT=$(gum choose --header "Fingerprint reader:" "true" "false")

TOUCHPAD="false"
BACKLIGHT="false"
if [ "$TYPE" = "laptop" ]; then
	TOUCHPAD=$(gum choose --header "Touchpad:" "true" "false")
	BACKLIGHT=$(gum choose --header "Backlight control:" "true" "false")
fi
echo

# Power settings for laptops
TLP="false"
START_THRESHOLD="65"
STOP_THRESHOLD="85"
if [ "$TYPE" = "laptop" ]; then
	gum style --foreground 212 "Power Management"
	TLP=$(gum choose --header "Enable TLP:" "true" "false")
	if [ "$TLP" = "true" ]; then
		START_THRESHOLD=$(gum input --placeholder "Start charge threshold %" --value "65")
		STOP_THRESHOLD=$(gum input --placeholder "Stop charge threshold %" --value "85")
	fi
	echo
fi

# Build summary for display
SUMMARY="## Host Configuration

**Metadata:**
- Name: $NAME
- Type: $TYPE
- Description: $DESCRIPTION"

[ -n "$HOSTNAME" ] && SUMMARY="$SUMMARY
- Hostname: $HOSTNAME"
[ -n "$KERNEL" ] && SUMMARY="$SUMMARY
- Kernel: $KERNEL"

SUMMARY="$SUMMARY

**Hardware:**
- Disk: $DISK
- RAM: ${RAM}GB
- CPU: $CPU
- GPU: $GPU"

[ -n "$HARDWARE_MODULE" ] && SUMMARY="$SUMMARY
- Module: $HARDWARE_MODULE"

SUMMARY="$SUMMARY

**Capabilities:**
- Bluetooth: $BLUETOOTH
- WiFi: $WIFI
- Fingerprint: $FINGERPRINT"

[ "$TYPE" = "laptop" ] && SUMMARY="$SUMMARY
- Touchpad: $TOUCHPAD
- Backlight: $BACKLIGHT"

if [ "$TYPE" = "laptop" ] && [ "$TLP" = "true" ]; then
	SUMMARY="$SUMMARY

**Power Management:**
- TLP: $TLP
- Charge Thresholds: ${START_THRESHOLD}% - ${STOP_THRESHOLD}%"
fi

# Show summary
gum style --foreground 212 "Summary:"
echo "$SUMMARY" | gum format
echo

gum confirm "Create this host?" || exit 0

# Generate hardware config
if gum confirm "Generate hardware configuration now? (requires root)"; then
	output_file="modules/system/hardware/hosts/$NAME.nix"
	gum spin --spinner dot --title "Generating hardware configuration..." -- \
		sudo nixos-generate-config --show-hardware-config --no-filesystems --root /tmp >"$output_file.tmp"

	# Wrap in module format
	cat >"$output_file" <<EOF
{ _, ... }:
{
  flake.nixosModules.hardware-$NAME =
$(cat "$output_file.tmp" | sed 's/^/    /');
}
EOF
	rm "$output_file.tmp"
	nix fmt "$output_file" 2>/dev/null || true
else
	gum style --foreground 220 "⚠ Remember to generate hardware config later with:"
	gum style --foreground 242 "   sudo nixos-generate-config --show-hardware-config --no-filesystems > modules/system/hardware/hosts/$NAME.nix"
fi

# Build JSON configuration
# Start with metadata
HOST_CONFIG=$(jq -n \
	--arg type "$TYPE" \
	--arg desc "$DESCRIPTION" \
	'{
        type: $type,
        description: $desc
    }')

# Add optional metadata fields
[ -n "$HOSTNAME" ] && HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --arg h "$HOSTNAME" '. + {hostname: $h}')
[ -n "$KERNEL" ] && HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --arg k "$KERNEL" '. + {kernel: $k}')

# Build hardware object
HARDWARE=$(jq -n \
	--arg disk "$DISK" \
	--argjson ram "$RAM" \
	--arg cpu "$CPU" \
	--arg gpu "$GPU" \
	--argjson bt "$BLUETOOTH" \
	--argjson wifi "$WIFI" \
	--argjson fp "$FINGERPRINT" \
	--argjson tp "$TOUCHPAD" \
	--argjson bl "$BACKLIGHT" \
	'{
        disk: $disk,
        ram: $ram,
        cpu: $cpu,
        gpu: $gpu,
        bluetooth: $bt,
        wifi: $wifi,
        fingerprint: $fp,
        touchpad: $tp,
        backlight: $bl
    }')

# Add optional hardware module
[ -n "$HARDWARE_MODULE" ] && HARDWARE=$(echo "$HARDWARE" | jq --arg m "$HARDWARE_MODULE" '. + {module: $m}')

# Add hardware to host config
HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --argjson hw "$HARDWARE" '. + {hardware: $hw}')

# Add power settings for laptops
if [ "$TYPE" = "laptop" ] && [ "$TLP" = "true" ]; then
	POWER=$(jq -n \
		--argjson tlp "$TLP" \
		--argjson start "$START_THRESHOLD" \
		--argjson stop "$STOP_THRESHOLD" \
		'{
            tlp: $tlp,
            startChargeThreshold: $start,
            stopChargeThreshold: $stop
        }')
	HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --argjson p "$POWER" '. + {power: $p}')
fi

# Update modules/config/hosts.toml
gum spin --spinner dot --title "Updating $CONFIG_FILE..." -- \
	bash -c "tomlq -t --arg name '$NAME' --argjson config '$HOST_CONFIG' \
        '.[\$name] = \$config' '$CONFIG_FILE' > '$CONFIG_FILE.tmp' && \
        mv '$CONFIG_FILE.tmp' '$CONFIG_FILE'"

echo
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "1 4" \
	"✓ Host '$NAME' added successfully!"

echo
gum style --foreground 242 "Next steps:"
echo "  • Edit $CONFIG_FILE to customize further"
echo "  • Generate flake: just flake"
echo "  • Install with: just install $NAME"
