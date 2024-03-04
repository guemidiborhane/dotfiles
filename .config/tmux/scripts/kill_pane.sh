#!/bin/sh

main() {
	panes_count=$(tmux list-panes -s | wc -l)
	default_shell=$(basename "$SHELL")
	current_shell=$(tmux display-message -p '#{pane_current_command}')

	pane_pid="$(tmux display -p "#{pane_pid}")"

	if [ "$panes_count" -gt 1 ] && [ "$current_shell" = "$default_shell" ]; then
		kill "$pane_pid"
	else
		tmux confirm-before -p "kill-pane #W:#P? (y/n)" "send-keys exit Enter"
	fi

	return 0
}

main
