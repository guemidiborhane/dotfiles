function ze --description "Browse zoxide directories with fzf and open in default file manager"
    argparse h/help 'f/file-manager=' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: ze [OPTIONS]"
        echo "Options:"
        echo "  -f, --file-manager FILE_MANAGER  Use different file manager (default: system default)"
        echo "  -h, --help                       Show this help"
        return 0
    end

    # Get default file manager command
    set file_manager_cmd
    if set -q _flag_file_manager
        set file_manager_cmd $_flag_file_manager
    else
        # Try to get default file manager from xdg
        set default_app (xdg-mime query default inode/directory 2>/dev/null)
        if test -n "$default_app"
            set file_manager_cmd gtk-launch $default_app
        else
            # Fallback to xdg-open if we couldn't determine the default
            set file_manager_cmd xdg-open
        end
    end

    # Get directory list from zoxide and let user select with fzf
    set selected (zoxide query -l | dmenu --placeholder="Select directory to open with file manager (ESC to cancel)")

    # Only launch file manager if a directory was selected and it exists
    if test -n "$selected" -a -d "$selected"
        $file_manager_cmd "$selected"
    end
end

# vim ft=fish
