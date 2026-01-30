#!/usr/bin/env bash
set -euo pipefail

gum style \
	--foreground 212 --border double --border-foreground 212 \
	--align center --width 50 --margin "1 2" --padding "1 4" \
	"NixOS Configuration Manager"

CHOICE=$(gum choose \
	--header "What would you like to do?" \
	--height 15 \
	"List all hosts" \
	"Show host configuration" \
	"Add new host" \
	"Remove host" \
	"Build configuration" \
	"Check build requirements" \
	"Install NixOS" \
	"Update flake" \
	"Validate config" \
	"Clean system" \
	"Show user config" \
	"Exit")

case "$CHOICE" in
"List all hosts")
	just list-hosts
	;;
"Show host configuration")
	just show-host
	;;
"Add new host")
	just add-host
	;;
"Remove host")
	just remove-host
	;;
"Build configuration")
	just build
	;;
"Check build requirements")
	just check-builds
	;;
"Install NixOS")
	just install
	;;
"Update flake")
	just update
	;;
"Validate config")
	just validate
	;;
"Clean system")
	just clean
	;;
"Show user config")
	just show-user
	;;
"Exit")
	gum style --foreground 242 "Goodbye!"
	;;
esac
