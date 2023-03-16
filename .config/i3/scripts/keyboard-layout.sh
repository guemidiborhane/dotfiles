#!/bin/sh
input-remapper-control --command stop-all && input-remapper-control --command autoload
notify-send "input remapper autoloaded"

setxkbmap -layout fr -variant us-azerty
notify-send "Keyboard layout set"
