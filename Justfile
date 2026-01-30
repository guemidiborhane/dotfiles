# Nix command with experimental features
nix := "nix --experimental-features 'nix-command flakes'"

# Interactive menu
[default]
menu:
    ./scripts/menu.sh

# Show this help message
help:
    @just --list --unsorted

# Enter development shell
dev:
    {{nix}} develop

# Show all configured hosts
list-hosts:
    #!/usr/bin/env bash
    tomlq -r '.hosts | to_entries[] |
        {
            key: .key,
            hostname: (.value.hostname // ""),
            type: .value.type,
            description: .value.description,
            cpu: .value.cpu,
            gpu: .value.gpu
        } |
        "\(.key)\(if .hostname != "" then " (\(.hostname))" else "" end),\(.type),\(.description),\(.cpu),\(.gpu)"
    ' config.toml | \
    gum table --columns "Name,Type,Description,CPU,GPU" --separator "," --border rounded --border.foreground 212 --print

# Show user configuration
show-user:
    #!/usr/bin/env bash
    tomlq '.user' config.toml

# Show host configuration
show-host host="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ host }}" ]; then
        HOST=$(just _pick-host)
    else
        HOST="{{ host }}"
    fi

    RESOLVED=$(just _resolve-host "$HOST")
    DISPLAY_NAME=$(tomlq -r ".hosts.\"$RESOLVED\".hostname // \"$RESOLVED\"" config.toml)

    tomlq ".hosts.\"$RESOLVED\"" config.toml

# Full system install
install host="" disk="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ host }}" ]; then
        HOST=$(just _pick-host)
    else
        HOST="{{ host }}"
    fi

    RESOLVED=$(just _resolve-host "$HOST")

    gum style --border double --padding "1 2" --border-foreground 212 \
        "Installing NixOS for: $RESOLVED"
    echo

    # Show configuration summary
    tomlq ".hosts.\"$RESOLVED\" | {type, disk, ram, cpu, gpu}" config.toml
    echo

    gum confirm "Proceed with installation?" || exit 0

    # Run disko
    just disko "$RESOLVED" "{{ disk }}"

    # Run nixos-install
    just nixos-install "$RESOLVED"

    echo
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 60 --margin "1 2" --padding "1 4" \
        "✓ Installation complete!"

    echo
    gum style --foreground 242 "Next steps:"
    USERNAME=$(just _get-username)
    echo "  cd /mnt && nixos-enter"
    echo "  passwd $USERNAME"
    echo "  exit && reboot"

# Partition and format disks
disko host="" disk="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ host }}" ]; then
        HOST=$(just _pick-host)
    else
        HOST="{{ host }}"
    fi

    RESOLVED=$(just _resolve-host "$HOST")
    DISK="{{ if disk == '' { `just _get-host-disk \"$RESOLVED\"` } else { disk } }}"

    gum style --border double --padding "1 2" --border-foreground 196 \
        "⚠ DESTRUCTIVE OPERATION ⚠"
    echo
    gum style --foreground 196 --bold "This will DESTROY all data on: $DISK"
    echo
    gum style --foreground 242 "Target host: $RESOLVED"
    echo

    if ! gum confirm "Are you absolutely sure?"; then
        gum style --foreground 242 "Aborted."
        exit 0
    fi

    gum style --foreground 220 "Starting in 5 seconds... (Ctrl+C to abort)"
    sleep 5

    gum spin --show-stderr --spinner dot --title "Running disko on $DISK..." -- \
        sudo {{nix}} run github:nix-community/disko -- \
            --mode disko --flake .#$RESOLVED

# Install NixOS
nixos-install host="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ host }}" ]; then
        HOST=$(just _pick-host)
    else
        HOST="{{ host }}"
    fi

    RESOLVED=$(just _resolve-host "$HOST")

    gum style --foreground 212 "Installing NixOS for: $RESOLVED"

    SUBS="$({{nix}} eval .#nixosConfigurations.$RESOLVED.config.nix.settings.extra-substituters --json | jq -r 'join(" ")')"
    KEYS="$({{nix}} eval .#nixosConfigurations.$RESOLVED.config.nix.settings.extra-trusted-public-keys --json | jq -r 'join(" ")')"

    sudo nixos-install --verbose --flake .#$RESOLVED \
        --option extra-substituters "$SUBS" \
        --option extra-trusted-public-keys "$KEYS"

# Add new host (interactive)
add-host name="":
    #!/usr/bin/env bash
    set -euo pipefail

    # Get host name
    if [ -z "{{ name }}" ]; then
        NAME=$(gum input --placeholder "Host name (e.g., kamui, takotsubo)")
    else
        NAME="{{ name }}"
    fi

    # Run the add-host script
    ./scripts/add-host.sh "$NAME"

# Remove host (interactive)
remove-host name="":
    #!/usr/bin/env bash
    set -euo pipefail

    # Run the remove-host script
    ./scripts/remove-host.sh "{{ name }}"

# Update flake
update:
    #!/usr/bin/env bash
    gum spin --show-stderr --spinner dot --title "Updating flake inputs..." -- {{nix}} flake update
    echo
    gum style --foreground 212 "✓ Flake updated successfully"
    echo
    gum style --foreground 242 "Run 'just check-builds <host>' to verify"

# Check build requirements
check-builds host="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ host }}" ]; then
        HOST=$(just _pick-host)
    else
        HOST="{{ host }}"
    fi

    RESOLVED=$(just _resolve-host "$HOST")
    gum style --foreground 212 "Checking build requirements for: $RESOLVED"
    {{nix}} build .#nixosConfigurations.$RESOLVED.config.system.build.toplevel --dry-run 2>&1 \
        | awk '/will be built:/,/will be fetched/' \
        | sed '1d;$d' | sed 's#.*/##' | rg -v 'completion'

rebuild-safe:
    @echo 'Not my style! Run: "nh os test" for all I care.'

# Rollback update
rollback-update:
    #!/usr/bin/env bash
    if gum confirm "Rollback flake.lock to previous version?"; then
        git checkout flake.lock
        gum style --foreground 212 "✓ Rolled back flake.lock"
    else
        gum style --foreground 242 "Cancelled"
    fi

# Validate config.toml
validate:
    #!/usr/bin/env bash
    if tomlq '.' config.toml > /dev/null 2>&1; then
        gum style --foreground 212 "✓ config.toml is valid"
    else
        gum style --foreground 196 "✗ config.toml has errors"
        exit 1
    fi

# Clean system
clean:
    #!/usr/bin/env bash
    gum style --foreground 220 "This will clean old generations and garbage collect"
    if gum confirm "Continue?"; then
        gum spin --show-stderr --spinner dot --title "Cleaning system..." -- nh clean all
        gum style --foreground 212 "✓ System cleaned successfully"
    else
        gum style --foreground 242 "Cancelled"
    fi

# Build configuration
build host="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ host }}" ]; then
        HOST=$(just _pick-host)
    else
        HOST="{{ host }}"
    fi

    RESOLVED=$(just _resolve-host "$HOST")
    gum style --foreground 212 "Building configuration for: $RESOLVED"
    {{nix}} build .#nixosConfigurations.$RESOLVED.config.system.build.toplevel

# Format nix files
fmt:
    {{nix}} fmt

# Helper: Get username from config
_get-username:
    @tomlq -r '.user.username' config.toml

# Helper: Pick a host interactively
_pick-host:
    #!/usr/bin/env bash
    HOSTS=$(tomlq -r '.hosts | to_entries[] | "\(.key)\(if .value.hostname then " (\(.value.hostname))" else "" end)"' config.toml)
    if [ -z "$HOSTS" ]; then
        gum style --foreground 196 "No hosts found in config.toml"
        exit 1
    fi
    SELECTED=$(echo "$HOSTS" | gum choose --header "Select host:")
    # Extract just the host key (before any parentheses)
    echo "$SELECTED" | awk '{print $1}'

# Helper: Resolve host name or hostname to actual host key
_resolve-host host:
    #!/usr/bin/env bash
    set -euo pipefail
    # First check if it's a direct host key
    if tomlq -e ".hosts.\"{{ host }}\"" config.toml >/dev/null 2>&1; then
        echo "{{ host }}"
        exit 0
    fi
    # Check if it matches a hostname
    RESOLVED=$(tomlq -r '.hosts | to_entries[] | select(.value.hostname == "{{ host }}") | .key' config.toml | head -n1)
    if [ -n "$RESOLVED" ]; then
        echo "$RESOLVED"
        exit 0
    fi
    echo "Error: Host '{{ host }}' not found (tried as name and hostname)" >&2
    exit 1

# Helper: Get hostname for a host (fallback to host name if not set)
_get-hostname host:
    #!/usr/bin/env bash
    RESOLVED=$(just _resolve-host {{ host }})
    tomlq -r ".hosts.\"$RESOLVED\".hostname // \"$RESOLVED\"" config.toml

# Helper: Get host disk
_get-host-disk host:
    #!/usr/bin/env bash
    RESOLVED=$(just _resolve-host {{ host }})
    tomlq -r ".hosts.\"$RESOLVED\".disk" config.toml

# Helper: Check if host exists
_host-exists host:
    @just _resolve-host {{ host }} >/dev/null 2>&1 && echo "true" || echo "false"
