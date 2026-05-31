function clip -d "Copy stdin to clipboard or paste from clipboard"
    argparse p/paste -- $argv

    set -l clipboard_cmd
    set -l paste_cmd

    switch $XDG_SESSION_TYPE
        case x11
            set clipboard_cmd xclip -sel clip
            set paste_cmd xclip -sel clip -o
        case wayland
            set clipboard_cmd wl-copy
            set paste_cmd wl-paste
        case '*'
            echo "Error: Unknown session type" >&2
            return 1
    end

    if test -n "$_flag_paste"
        $paste_cmd
    else
        $clipboard_cmd
    end
end

# vim: set ft=fish
