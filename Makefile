.PHONY: help install disko nixos-install update check-builds rebuild-safe

# Default target
help:
	@echo "NixOS Configuration Management"
	@echo ""
	@echo "Installation (from live USB):"
	@echo "  make install        - Full system install (disko + nixos-install)"
	@echo "  make disko          - Partition and format disks only"
	@echo ""
	@echo "Daily Usage (use nh instead):"
	@echo "  nh os switch        - Rebuild and switch"
	@echo "  nh os boot          - Rebuild and switch on next boot"
	@echo "  nh os test          - Test without switching"
	@echo "  nh clean all        - Garbage collection (automated via config)"
	@echo ""
	@echo "Emergency Recovery (from live USB):"
	@echo "  make mount          - Mount encrypted system to /mnt"
	@echo "  make umount         - Unmount system"
	@echo ""
	@echo "Variables:"
	@echo "  HOST=nixos      - Target host (default: nixos)"
	@echo "  DISK=/dev/sda       - Target disk for installation (default: /dev/sda)"

# Configuration
HOST ?= nixos
DISK ?= /dev/sda
CONFIG := .\#$(HOST)

# Installation (only used during initial setup)
install: disko nixos-install
	@echo ""
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  # cd /mnt"
	@echo "  # nixos-enter"
	@echo "  # sudo passwd borhane"
	@echo "  # Daily rebuilds: nh os switch"

disko:
	@echo "⚠️  WARNING: This will DESTROY all data on $(DISK)"
	@echo "Press Ctrl+C within 10 seconds to cancel..."
	@sleep 10
	@echo "Partitioning $(DISK)..."
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
		--mode disko \
		--flake $(CONFIG)

nixos-install:
	@echo "Installing NixOS..."
	sudo nixos-install --verbose --flake $(CONFIG)

update:
	@echo "Updating flake inputs..."
	@cp flake.lock flake.lock.bak
	@nix flake update
	@echo "✓ Updated. Run 'make check-builds' to verify cache status"

check-builds:
	@echo "Checking what needs building..."
	@nix build .#nixosConfigurations.$(HOST).config.system.build.toplevel --dry-run 2>&1 | \
		awk '/will be built/{flag=1} flag' | \
		head -20

rebuild-safe:
	@echo "Rebuilding only if cache hits..."
	@BUILD_COUNT=$$(nix build .#nixosConfigurations.$(HOST).config.system.build.toplevel --dry-run 2>&1 | grep -c "will be built" || echo 0); \
	if [ "$$BUILD_COUNT" -gt 10 ]; then \
		echo "❌ Too many builds needed ($$BUILD_COUNT packages)"; \
		echo "Restore old lock: mv flake.lock.bak flake.lock"; \
		exit 1; \
	else \
		echo "✓ Proceeding ($$BUILD_COUNT builds needed)"; \
		nh os switch; \
		rm -f flake.lock.bak; \
	fi

rollback-update:
	@mv flake.lock.bak flake.lock
	@echo "✓ Rolled back to previous flake.lock"
