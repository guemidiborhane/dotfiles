.PHONY: help install disko mount umount

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

# Emergency recovery
mount:
	@echo "Mounting encrypted system..."
	sudo cryptsetup luksOpen $(DISK)2 crypted || true
	sudo vgchange -ay $(HOST)-vg
	sudo mount /dev/$(HOST)-vg/root /mnt
	sudo mount $(DISK)1 /mnt/boot
	@echo ""
	@echo "✓ System mounted at /mnt"
	@echo "Run 'sudo nixos-enter' to chroot"

umount:
	@echo "Unmounting system..."
	-sudo umount /mnt/boot
	-sudo umount /mnt
	sudo vgchange -an $(HOST)-vg
	sudo cryptsetup luksClose crypted
	@echo "✓ System unmounted"
