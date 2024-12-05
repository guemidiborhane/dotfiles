#!/bin/sh
# /usr/bin/i3exit

# with openrc use loginctl
[ "$(cat /proc/1/comm)" = "systemd" ] && logind=systemctl || logind=loginctl

case "$1" in
lock)
    ~/.local/bin/blurlock
    ;;
logout)
    ~/.config/i3/scripts/save-workspaces.sh
    loginctl terminate-user $USER
    ;;
switch_user)
    dm-tool switch-to-greeter
    ;;
suspend)
    $logind suspend
    ;;
hibernate)
    $logind hibernate
    ;;
reboot)
    ~/.config/i3/scripts/save-workspaces.sh
    $logind reboot
    ;;
shutdown)
    ~/.config/i3/scripts/save-workspaces.sh
    $logind poweroff
    ;;
*)
    echo "== ! i3exit: missing or invalid argument ! =="
    echo "Try again with: lock | logout | switch_user | suspend | hibernate | reboot | shutdown"
    exit 2
    ;;
esac

exit 0
