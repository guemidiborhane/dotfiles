function mkcd --argument name
    set -q name[1]; or return

    mkdir $name
    cd $name
end

# vim: ft=fish
