if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1 -a -z "$SSH_CONNECTION" -a (tty | string match -r '/dev/tty[0-9]+')
        set script (~/.config/hypr/hyprstart)
        if test -f "$script"
            exec sh -c "$script"
        end
    end
end

# vim: ft=fish
