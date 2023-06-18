# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "monitors"

# Split window into panes.
# run_cmd "doas nethogs wlan0 tun0 -b"
run_cmd "doas nethogs wlan0 tun0 -b"
split_v 88
run_cmd "btop"
split_v 12
run_cmd "watch -n 1 -d -t aio_speeds"
split_h 80
run_cmd "watch -t -x sh -c \"cowsay 'keep calm and enjoy paranoia'| center.sh\""
split_h 20
run_cmd "watch -n 1 -d -t -x cpu_temps"

# Set active pane.
select_pane 1
