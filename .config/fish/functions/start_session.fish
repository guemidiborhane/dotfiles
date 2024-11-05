function start_session
    # Define mapping of display names to internal keys
    set -l options \
        "Hyprland:~/.config/hypr/hyprstart" \
        "i3:startx"

    # Parse options to get just the display names for fzf
    set -l display_options
    for opt in $options
        set -a display_options (string split ":" $opt)[1]
    end

    # Show options in fzf and get selected
    set selected (printf "%s\n" $display_options | fzf --reverse)
    
    # Find the corresponding internal key for the selected display name
    if test -n "$selected"
        for opt in $options
            set -l parts (string split ":" $opt)
            if test "$parts[1]" = "$selected"
                echo $parts[2]
                break
            end
        end
    end
end

# vim: ft=fish
