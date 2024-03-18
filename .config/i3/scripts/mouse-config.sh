#!/bin/sh
# vim: set ft=sh sw=4 et :

solaar config 1 dpi 800
xinput set-prop "pointer:Logitech MX Master 3" "libinput Accel Speed" -0.5
xinput set-prop "pointer:Logitech MX Master 3" 'libinput Accel Profile Enabled' 0, 1
notify-send 'Configured Logitech MX Master 3'
