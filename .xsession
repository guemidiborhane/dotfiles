#!/bin/sh
# vim: set ft=sh sw=4 et :

input-remapper-control --command stop-all && input-remapper-control --command autoload
solaar config 1 dpi 800
solaar config 1 hires-smooth-invert true
xinput set-prop "pointer:Logitech MX Master 3" "libinput Accel Speed" -0.5
xinput set-prop "pointer:Logitech MX Master 3" 'libinput Accel Profile Enabled' 0, 1
