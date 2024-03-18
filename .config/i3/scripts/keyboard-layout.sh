#!/bin/sh
input-remapper-control --command stop-all && input-remapper-control --command autoload
notify-send "input remapper autoloaded"

sleep 1

setxkbmap -layout fr -variant us-azerty
notify-send "Keyboard layout set"
