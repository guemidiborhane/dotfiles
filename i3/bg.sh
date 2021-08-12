
#!/usr/bin/bash
files=(~/Pictures/wallpapers/*)
WALLPAPER1=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER3=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
DISPLAY=:0 feh -B white --bg-fill "$WALLPAPER1" --bg-fill "$WALLPAPER2" --bg-fill "$WALLPAPER3"
# XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -u low "wallpaper changed"
