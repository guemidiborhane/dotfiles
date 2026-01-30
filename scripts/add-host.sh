#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="config.toml"
NAME="$1"

# Check if host exists
if tomlq -e ".hosts.\"$NAME\"" "$CONFIG_FILE" >/dev/null 2>&1; then
    gum style --foreground 196 "Error: Host '$NAME' already exists"
    exit 1
fi

# Interactive inputs
gum style --foreground 212 "Host Type"
TYPE=$(gum choose --header "Select type:" "laptop" "desktop" "server" "headless")
echo

gum style --foreground 212 "Hardware Configuration"
DISK=$(gum input --placeholder "Disk device (e.g., /dev/sda, /dev/nvme0n1)" --value "/dev/sda")
RAM=$(gum input --placeholder "RAM in GB" --value "16")
CPU=$(gum choose --header "CPU vendor:" "intel" "amd")
GPU=$(gum choose --header "GPU vendor:" "intel" "amd" "nvidia" "hybrid")
echo

gum style --foreground 212 "Optional Settings"
HOSTNAME=$(gum input --placeholder "Short hostname (optional, press enter to skip)")
HARDWARE=$(gum input --placeholder "nixos-hardware module (optional, e.g., dell-latitude-7490)")
DESCRIPTION=$(gum input --placeholder "Description" --value "$NAME")
echo

# Features
gum style --foreground 212 "Features"
BLUETOOTH=$(gum choose --header "Bluetooth:" "true" "false")
WIFI=$(gum choose --header "WiFi:" "true" "false")

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

- **Name**: $NAME
- **Type**: $TYPE
- **Disk**: $DISK
- **RAM**: ${RAM}GB
- **CPU**: $CPU
- **GPU**: $GPU"

[ -n "$HOSTNAME" ] && SUMMARY="$SUMMARY
- **Hostname**: $HOSTNAME"
[ -n "$HARDWARE" ] && SUMMARY="$SUMMARY
- **Hardware Module**: $HARDWARE"

SUMMARY="$SUMMARY
- **Description**: $DESCRIPTION

### Features
- Bluetooth: $BLUETOOTH
- WiFi: $WIFI"

[ "$TYPE" = "laptop" ] && SUMMARY="$SUMMARY
- Touchpad: $TOUCHPAD
- Backlight: $BACKLIGHT"

if [ "$TYPE" = "laptop" ] && [ "$TLP" = "true" ]; then
    SUMMARY="$SUMMARY

### Power Management
- TLP: $TLP
- Charge Thresholds: ${START_THRESHOLD}% - ${STOP_THRESHOLD}%"
fi

# Show summary
gum style --foreground 212 "Summary:"
echo "$SUMMARY" | gum format
echo

gum confirm "Create this host?" || exit 0

# Create directory
gum spin --spinner dot --title "Creating host directory..." -- mkdir -p "hosts/$NAME"

# Generate hardware config
if gum confirm "Generate hardware configuration now? (requires root)"; then
    gum spin --spinner dot --title "Generating hardware configuration..." -- \
        nixos-generate-config --show-hardware-config --no-filesystems > \
        "hosts/$NAME/hardware-configuration.nix"
else
    gum style --foreground 220 "⚠ Remember to generate hardware-configuration.nix later"
fi

# Build JSON configuration
HOST_CONFIG=$(jq -n \
    --arg type "$TYPE" \
    --arg disk "$DISK" \
    --argjson ram "$RAM" \
    --arg cpu "$CPU" \
    --arg gpu "$GPU" \
    --arg desc "$DESCRIPTION" \
    '{
        type: $type,
        disk: $disk,
        ram: $ram,
        cpu: $cpu,
        gpu: $gpu,
        description: $desc
    }')

# Add optional fields
[ -n "$HOSTNAME" ] && HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --arg h "$HOSTNAME" '. + {hostname: $h}')
[ -n "$HARDWARE" ] && HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --arg hw "$HARDWARE" '. + {hardware: $hw}')

# Add features
FEATURES=$(jq -n \
    --argjson bt "$BLUETOOTH" \
    --argjson wifi "$WIFI" \
    --argjson tp "$TOUCHPAD" \
    --argjson bl "$BACKLIGHT" \
    '{
        bluetooth: $bt,
        wifi: $wifi,
        touchpad: $tp,
        backlight: $bl
    }')

HOST_CONFIG=$(echo "$HOST_CONFIG" | jq --argjson f "$FEATURES" '. + {features: $f}')

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

# Update config.toml
gum spin --spinner dot --title "Updating config.toml..." -- \
    bash -c "tomlq -t --arg name '$NAME' --argjson config '$HOST_CONFIG' \
        '.hosts[\$name] = \$config' '$CONFIG_FILE' > '$CONFIG_FILE.tmp' && \
        mv '$CONFIG_FILE.tmp' '$CONFIG_FILE'"

echo
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "1 4" \
    "✓ Host '$NAME' added successfully!"

echo
gum style --foreground 242 "Next steps:"
echo "  • Edit config.toml to customize further"
echo "  • Install with: just install $NAME"
