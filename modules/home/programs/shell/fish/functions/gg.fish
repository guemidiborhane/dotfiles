function gg
    # Check if current directory is inside a git repository
    if command git rev-parse --git-dir >/dev/null 2>&1 || not string match -q "/home/*" $PWD
        # Launch lazygit in current git repo
        tmux_popup -w 90% -h 90% lazygit
    else
        # Launch lazygit for yadm (dotfiles)
        tmux_popup -w 90% -h 90% yadm enter lazygit
    end
end

# vim ft=fish
