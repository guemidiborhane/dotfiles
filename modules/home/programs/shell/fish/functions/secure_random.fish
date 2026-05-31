function secure_random --argument size
    set -q size[1]; or set size 64
    tr -cd '[:alnum:]' </dev/urandom | fold -w $size | head -n 1 | tr -d '\n' | tee /dev/tty | clip
end

# vim: ft=fish
