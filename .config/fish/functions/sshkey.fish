function sshkey -d "Select and copy SSH public key to clipboard"
    # Parse arguments
    argparse p/print -- $argv
    or return 1

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
    set selected (printf '%s\n' $key_names | dmenu --placeholder="Select SSH key")

    # If selection was made, either print or copy
    if test -n "$selected"
        set ssh_key_path "$HOME/.ssh/$selected.pub"

        if test -f "$ssh_key_path"
            if set -q _flag_print
                # Print mode: output the path
                echo "$ssh_key_path"
            else
                # Copy mode: copy to clipboard
                cat "$ssh_key_path" | string trim | clip

                # Send notification if notify-send is available
                if command -q notify-send
                    notify-send -t 5000 "$selected public key copied to clipboard" -i ~/.icons/key_ok.png
                else
                    echo "✓ $selected public key copied to clipboard"
                end
            end
        else
            echo "Key file not found: $ssh_key_path" >&2
            return 1
        end
    end
end

# vim ft=fish
