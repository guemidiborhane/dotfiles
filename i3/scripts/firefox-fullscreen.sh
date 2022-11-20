#!/bin/sh
# Get active window properties for writing `for_window` rules
# In ~/.i3/config:
#    bindsym $mod2+f ~/.config/i3/scripts/firefox-fullscreen.sh

i3-msg fullscreen toggle
sleep 0.3
xdotool key --window $(xdotool getactivewindow) f
