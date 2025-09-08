function sync
    # Find all executable files named 'sync' in ~/.config/yadm recursively
    for script in (fd --type executable sync ~/.config/yadm 2>/dev/null)
        read -P "Execute $script? [Y/n] " -l confirm
        if test "$confirm" = y -o "$confirm" = Y -o "$confirm" = ""
            echo "Executing: $script"
            $script
        else if test "$confirm" = n -o "$confirm" = N
            echo "Skipped: $script"
        end
    end
end
# vim ft=fish
