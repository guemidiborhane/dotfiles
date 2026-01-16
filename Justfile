# Show this help message
[default]
@help:
    just --list --unsorted

# Enter development shell
dev:
    nix develop

# Show all configured hosts
list-hosts:
    @echo "Configured hosts:"
    @nix eval --json --file - <<< 'builtins.attrNames (builtins.fromTOML (builtins.readFile ./config.toml)).hosts' | \
        jq -r '.[]' | while read host; do \
            type=$(nix eval --raw --file - <<< "(builtins.fromTOML (builtins.readFile ./config.toml)).hosts.\"$host\".type"); \
            desc=$(nix eval --raw --file - <<< "(builtins.fromTOML (builtins.readFile ./config.toml)).hosts.\"$host\".description"); \
            echo "  • $host ($type) - $desc"; \
        done

# Show full configuration
show-config:
    @cat config.toml

# Show user configuration
show-user:
    @echo "User Configuration:"
    @nix eval --json --file - <<< '(builtins.fromTOML (builtins.readFile ./config.toml)).user' | jq

# Show host configuration
show-host host="":
    @echo "Configuration for {{ if host == "" { "$(hostname)" } else { host } }}:"
    @nix eval --json --file - <<< "(builtins.fromTOML (builtins.readFile ./config.toml)).hosts.\"{{ if host == "" { "$(hostname)" } else { host } }}\"" | jq

# Full system install
install host disk="": (disko host disk) (nixos-install host)
    @echo ""
    @echo "Installation complete!"
    @echo ""
    @echo "Next steps:"
    @echo "  cd /mnt && nixos-enter"
    @echo "  passwd $(just _get-username)"
    @echo "  exit && reboot"

# Partition and format disks
disko host disk="":
    #!/usr/bin/env bash
    set -euo pipefail

    DISK="{{ if disk == '' { `just _get-host-disk {{host}}` } else { disk } }}"

    echo "WARNING: This will DESTROY all data on $DISK"
    echo "Press Ctrl+C within 10 seconds to cancel..."
    sleep 10
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
        --mode disko --flake .#{{host}}

# Install NixOS
nixos-install host:
    sudo nixos-install --verbose --flake .#{{host}}

# Add new host
add-host name type="laptop" disk="/dev/sda" ram="16" cpu="intel" gpu="intel" description="" hardware="":
    #!/usr/bin/env bash
    set -euo pipefail

    # Check if host exists
    if grep -q "^\[hosts\.{{name}}\]" config.toml; then
        echo "Error: Host '{{name}}' already exists"
        exit 1
    fi

    # Create directory
    mkdir -p hosts/{{name}}

    # Generate hardware config
    echo "Generating hardware configuration..."
    nixos-generate-config --show-hardware-config --no-filesystems > \
        hosts/{{name}}/hardware-configuration.nix

    # Add to config.toml
    DESC="{{ if description == '' { name } else { description } }}"
    cat >> config.toml <<EOF

    [hosts.{{name}}]
    type = "{{type}}"
    disk = "{{disk}}"
    ram = {{ram}}
    cpu = "{{cpu}}"
    gpu = "{{gpu}}"
    description = "$DESC"
    EOF

    if [ -n "{{hardware}}" ]; then
        echo "hardware = \"{{hardware}}\"" >> config.toml
    fi

    cat >> config.toml <<EOF

    [hosts.{{name}}.features]
    bluetooth = true
    wifi = true
    EOF

    if [ "{{type}}" = "laptop" ]; then
        cat >> config.toml <<EOF
    touchpad = true
    backlight = true

    [hosts.{{name}}.power]
    tlp = true
    startChargeThreshold = 65
    stopChargeThreshold = 85
    EOF
    fi

    echo ""
    echo "Host '{{name}}' added successfully!"
    echo "Edit config.toml to customize further"
    echo ""
    echo "Install with: just install {{name}}"

# Remove host
remove-host name:
    #!/usr/bin/env bash
    set -euo pipefail

    if ! grep -q "^\[hosts\.{{name}}\]" config.toml; then
        echo "Error: Host '{{name}}' not found"
        exit 1
    fi

    read -p "Remove host '{{name}}'? (y/N) " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

    rm -rf "hosts/{{name}}"

    # Remove from config.toml
    sed -i '/^\[hosts\.{{name}}\]/,/^\[hosts\./{ /^\[hosts\.{{name}}\]/d; /^\[hosts\./!d; }' config.toml
    sed -i '/^\[hosts\.{{name}}\]/,/^$/d' config.toml

    echo "Host '{{name}}' removed"

# Update flake
update:
    nix flake update
    @echo "Run 'just check-builds <host>' to verify"

# Check build requirements
check-builds host="":
    @nix build .#nixosConfigurations.{{ if host == "" { "$(hostname)" } else { host } }}.config.system.build.toplevel --dry-run 2>&1 | \
        awk '/will be built/{flag=1} flag' | head -20

# Rebuild safely
needs-build host="":
    #!/usr/bin/env bash
    set -euo pipefail
    nix build .#nixosConfigurations.{{ if host == "" { "$(hostname)" } else { host } }}.config.system.build.toplevel --dry-run 2>&1 \
        | awk '/will be built:/,/will be fetched/' \
        | sed '1d;$d' | sed 's#.*/##' \
        | grep -Ei -f build-watch.list | wc -l

# Rollback update
rollback-update:
    git checkout flake.lock
    @echo "Rolled back flake.lock"

# Validate config.toml
validate:
    @nix eval --json --file - <<< 'builtins.fromTOML (builtins.readFile ./config.toml)' > /dev/null && \
        echo "config.toml is valid" || echo "config.toml has errors"

# Clean system
clean:
    nh clean all

# Build configuration
build host="":
    nix build .#nixosConfigurations.{{ if host == "" { "$(hostname)" } else { host } }}.config.system.build.toplevel

# Format nix files
fmt:
    nix fmt

# Helper: Get username from config
_get-username:
    @nix eval --raw --file - <<< '(builtins.fromTOML (builtins.readFile ./config.toml)).user.username'

# Helper: Get host disk
_get-host-disk host="":
    @nix eval --raw --file - <<< "(builtins.fromTOML (builtins.readFile ./config.toml)).hosts.\"{{ if host == "" { "$(hostname)" } else { host } }}\".disk"
