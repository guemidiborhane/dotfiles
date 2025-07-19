function tn --argument session_name
    set -q session_name[1]; or set session_name (basename $PWD)

    if not tmux has-session -t "$session_name"
        dr --slice tmux --unit "$session_name-session" -- tmux new-session -ds "$session_name"

        # Wait for session with timeout
        set -l timeout 50 # 5 seconds (50 * 0.1s)
        while not tmux has-session -t "$session_name"; and test $timeout -gt 0
            sleep 0.1
            set timeout (math $timeout - 1)
        end

        if test $timeout -eq 0
            echo "Timeout waiting for tmux session '$session_name'" >&2
            return 1
        end
    end

    if test -z "$TMUX"
        tmux attach-session -t "$session_name"
    else 
        tmux switch-client -t "$session_name"
    end
end

# vim ft=fish
