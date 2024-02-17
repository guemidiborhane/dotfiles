#!/bin/sh

main() {
	panes_count=$(tmux list-panes -s | wc -l)
	default_shell=$(basename "$SHELL")
	current_shell=$(tmux display-message -p '#{pane_current_command}')

	if [ "$panes_count" -gt 1 ] && [ "$current_shell" = "$default_shell" ]; then
		tmux kill-pane
	else
		tmux confirm-before -p "kill-pane #W? (y/n)" kill-pane
	fi

	return 0
}

main
