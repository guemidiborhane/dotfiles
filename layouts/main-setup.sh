#!/bin/sh
xrandr \
    --output DP-0 --mode 2560x1440 --pos 0x560 --rotate normal --rate 74.97 \
    --output DP-2 --mode 2560x1440 --pos 5120x0 --rotate right --rate 74.97 \
    --output DP-4 --primary --mode 2560x1440 --pos 2560x560 --rotate normal --rate 74.97
