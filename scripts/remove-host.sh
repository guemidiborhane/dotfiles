#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="config.toml"
SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(cd "$SCRIPTS_DIR/.." && pwd)"

cd "$REPO_ROOT"

# Get host name from argument or prompt
if [ -z "${1:-}" ]; then
    HOSTS=$(tomlq -r '.hosts | keys[]' "$CONFIG_FILE")
    if [ -z "$HOSTS" ]; then
        gum style --foreground 196 "No hosts found in config.toml"
        exit 1
    fi
    NAME=$(echo "$HOSTS" | gum choose --header "Select host to remove:")
else
    NAME="$1"
fi

# Resolve the host (check if exists as name or hostname)
if tomlq -e ".hosts.\"$NAME\"" "$CONFIG_FILE" >/dev/null 2>&1; then
    RESOLVED="$NAME"
else
    # Try to find by hostname
    RESOLVED=$(tomlq -r ".hosts | to_entries[] | select(.value.hostname == \"$NAME\") | .key" "$CONFIG_FILE" | head -n1)
    if [ -z "$RESOLVED" ]; then
        gum style --foreground 196 "Error: Host '$NAME' not found (tried as name and hostname)"
        exit 1
    fi
fi

# Show host info before removal
gum style --border double --padding "1 2" --border-foreground 196 "Host to be removed: $RESOLVED"
echo
tomlq ".hosts.\"$RESOLVED\"" "$CONFIG_FILE"
echo

gum style --foreground 196 "⚠ This will:"
echo "  • Delete hosts/$RESOLVED directory"
echo "  • Remove configuration from config.toml"
echo

gum confirm "Are you sure you want to remove '$RESOLVED'?" || exit 0

# Remove directory
if [ -d "hosts/$RESOLVED" ]; then
    gum spin --spinner dot --title "Removing host directory..." -- rm -rf "hosts/$RESOLVED"
fi

# Remove from config.toml
gum spin --spinner dot --title "Updating config.toml..." -- \
    bash -c "tomlq -t 'del(.hosts.\"$RESOLVED\")' '$CONFIG_FILE' > '$CONFIG_FILE.tmp' && \
        mv '$CONFIG_FILE.tmp' '$CONFIG_FILE'"

echo
gum style \
    --foreground 196 --border-foreground 196 --border double \
    --align center --width 50 --margin "1 2" --padding "1 4" \
    "✓ Host '$RESOLVED' removed successfully"
