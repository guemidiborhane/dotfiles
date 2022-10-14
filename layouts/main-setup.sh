#!/bin/sh
xrandr \
    --output DP-0 --mode 2560x1440 --pos 4000x560 --rotate normal --rate 59.95 \
    --output DP-2 --mode 2560x1440 --pos 0x0 --rotate left --rate 59.95 \
    --output DP-4 --primary --mode 2560x1440 --pos 1440x560 --rotate normal --rate 59.95
