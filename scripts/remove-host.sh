#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$1"
RESOLVED="$2"
HARDWARE_FILE="modules/system/hardware/hosts/$RESOLVED.nix"
SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(cd "$SCRIPTS_DIR/.." && pwd)"

cd "$REPO_ROOT"

# Show host info before removal
gum style --border double --padding "1 2" --border-foreground 196 "Host to be removed: $RESOLVED"
echo
tomlq ".\"$RESOLVED\"" "$CONFIG_FILE"
echo

gum style --foreground 196 "⚠ This will:"
echo "  • Delete $HARDWARE_FILE"
echo "  • Remove configuration from $CONFIG_FILE"
echo

gum confirm "Are you sure you want to remove '$RESOLVED'?" || exit 0

# Remove directory
if [ -f "$HARDWARE_FILE" ]; then
	gum spin --spinner dot --title "Removing host directory..." -- rm "$HARDWARE_FILE"
fi

# Remove from modules/config/hosts.toml
gum spin --spinner dot --title "Updating $CONFIG_FILE..." -- \
	bash -c "tomlq -t 'del(.\"$RESOLVED\")' '$CONFIG_FILE' > '$CONFIG_FILE.tmp' && \
        mv '$CONFIG_FILE.tmp' '$CONFIG_FILE'"

echo
gum style \
	--foreground 196 --border-foreground 196 --border double \
	--align center --width 50 --margin "1 2" --padding "1 4" \
	"✓ Host '$RESOLVED' removed successfully"
