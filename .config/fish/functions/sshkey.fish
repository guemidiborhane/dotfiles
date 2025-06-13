function sshkey -d "Select and copy SSH public key to clipboard"
    # Find all public key files
    set keys ~/.ssh/*.pub

    # Check if any keys exist
    if not test -e $keys[1]
        echo "No public keys found in ~/.ssh/" >&2
        return 1
    end

    # Extract key names (remove path and .pub extension)
    set key_names
    for key in $keys
        set -a key_names (basename $key .pub)
    end

    # Let user select a key
    set selected (printf '%s\n' $key_names | fzf --prompt="Select SSH key to copy: " --height=10)

    # If selection was made, copy to clipboard
    if test -n "$selected"
        set ssh_key_path "$HOME/.ssh/$selected.pub"

        if test -f "$ssh_key_path"
            cat "$ssh_key_path" | string trim | clip

            # Send notification if notify-send is available
            if command -q notify-send
                notify-send -t 5000 "$selected public key copied to clipboard" -i ~/.icons/key_ok.png
            else
                echo "✓ $selected public key copied to clipboard"
            end
        else
            echo "Key file not found: $ssh_key_path" >&2
            return 1
        end
    end
end

# vim ft=fish
