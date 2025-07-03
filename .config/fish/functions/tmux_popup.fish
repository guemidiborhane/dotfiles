function tmux_popup -d "Run command in tmux popup or directly if not in tmux"
    if test (count $argv) -eq 0
        echo "Usage: tmux_popup <command> [args...]" >&2
        echo "Example: tmux_popup yadm enter lazygit" >&2
        return 1
    end

    if test -z "$TMUX"
        $argv
    else
        tmux popup -d '#{pane_current_path}' -w 90% -h 90% -E $argv
    end
end

# vim ft=fish
