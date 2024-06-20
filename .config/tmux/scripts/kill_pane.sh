#!/bin/sh

main() {
	panes_count=$(tmux list-panes -s | wc -l)
	default_shell=$(basename "$SHELL")
	current_shell=$(tmux display-message -p '#{pane_current_command}')

	pane_pid="$(tmux display -p "#{pane_pid}")"

	if [ "$panes_count" -gt 1 ]; then
		tmux send-keys C-d
	else
		tmux display-popup -w 25 -h 7 -E gum confirm "kill-pane ?" --default=0 --timeout=3s --no-show-help

		if [ $? -eq 0 ]; then
			 tmux send-keys C-d
		fi
	fi

	return 0
}

main
