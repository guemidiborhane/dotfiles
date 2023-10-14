#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_fish_pkg() {
	yay -S --needed --noconfirm fish starship figlet
	touch "$HOME/.fish_history" # Fix for mcfly
}

fish_main() {
	section "fish"
	install_fish_pkg
}
