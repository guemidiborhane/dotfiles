#!/bin/sh

killall -9 hyprlock
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
hyprctl --instance 0 dispatch exec hyprlock
