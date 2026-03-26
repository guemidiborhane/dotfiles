function pwd
    set dir (/usr/bin/env pwd)
    echo $dir
    echo -n $dir | clip
end

# vim ft=fish
