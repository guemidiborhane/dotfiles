function tn --argument session_name
    set -q session_name[1]; or set session_name (basename $PWD)

    if not tmux has-session -t "$session_name"
        tmux new-session -ds "$session_name"
    end

    if test -z "$TMUX"
        tmux attach-session -t "$session_name"
    else 
        tmux switch-client -t "$session_name"
    end
end

# vim ft=fish
