function git --wraps git
    # Check if current directory is inside a git repository
    if command git rev-parse --git-dir >/dev/null 2>&1 || not string match -q "/home/*" $PWD
        command git $argv
    else
        command yadm $argv
    end
end

# vim ft=fish
