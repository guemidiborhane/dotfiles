function pwd
    set dir (/usr/bin/pwd)
    echo $dir
    echo -n $dir | xclip -sel clipboard
end

# vim ft=fish
