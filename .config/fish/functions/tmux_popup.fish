function tmux_popup -d "Run command in tmux popup or directly if not in tmux"
    if test (count $argv) -eq 0
        echo "Usage: tmux_popup <command> [args...]" >&2
        echo "Example: tmux_popup yadm enter lazygit" >&2
        return 1
    end

    if test -z "$TMUX"
        # Filter out tmux-specific options when not in tmux
        set -l filtered_args
        set -l skip_next false

        for arg in $argv
            if test "$skip_next" = true
                set skip_next false
                continue
            end

            switch $arg
                case -w -h -x -y -S -t -d
                    set skip_next true
                case '-*'
                    # Skip other tmux popup flags
                    continue
                case '*'
                    set -a filtered_args $arg
            end
        end

        $filtered_args
    else
        tmux popup -d '#{pane_current_path}' -E $argv
    end
end

# vim ft=fish
