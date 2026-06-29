#!/usr/bin/env sh

# Detect available task runner(s)
has_just=0
has_make=0
[ -f justfile ] || [ -f Justfile ] || [ -f .justfile ] && has_just=1
[ -f Makefile ] || [ -f makefile ] && has_make=1

[ "$has_just" -eq 0 ] && [ "$has_make" -eq 0 ] && exit 0

# If both are present, let the user pick; otherwise use what's available
if [ "$has_just" -eq 1 ] && [ "$has_make" -eq 1 ]; then
	runner="$(printf 'just\nmake' | fzf-tmux -p --prompt='runner> ')"
	[ -z "$runner" ] && exit 0
elif [ "$has_just" -eq 1 ]; then
	runner="just"
else
	runner="make"
fi

# List tasks depending on runner
case "$runner" in
just)
	task="$(just --list --list-prefix '' --list-heading '' |
		awk '{print $1}' |
		fzf-tmux -p --prompt='task> ')"
	;;
make)
	task="$(make -qp |
		awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {
          split($1, A, / /); for (i in A) print A[i]
        }' |
		sort -u |
		fzf-tmux -p --prompt='task> ')"
	;;
esac

[ -z "$task" ] && exit 0

breakout_type="$(printf 'hsplit\nvsplit\nwindow' | fzf-tmux -p --prompt='open in> ')"
[ -z "$breakout_type" ] && exit 0

case "$breakout_type" in
window) tmux_pane_cmd="new-window -n $task" ;;
hsplit) tmux_pane_cmd="split-window -h" ;;
vsplit) tmux_pane_cmd="split-window" ;;
esac

tmux $tmux_pane_cmd -c "#{pane_current_path}" \
	"sh -c '$runner $task; echo; printf \"[exited \$?] press enter to close\"; read _'"
