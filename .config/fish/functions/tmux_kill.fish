function tmux_kill
    set sessions (tmux list-session -F '#{session_name}' | gum filter --no-limit --placeholder 'Pick a sesh' --prompt=' ')
    if test -n "$sessions"
        for session in $sessions
            if tmux has-session -t "$session"
                tmux kill-session -t "$session"
                echo "Killed session: $session"
            end
        end
    else
        echo "No sessions selected"
    end
end

# vim ft=fish
