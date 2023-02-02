#!/bin/sh
# vim: set ft=sh sw=4 et :

ask () {
    if [ "$INSTALL_ALL" = "yes" ]; then
        return 0
    fi

    read -p "$1? [y/N] " -n 1 -r
    echo   # (optional) move to a new line
}

section () {
    echo
    echo "===================="
    echo " $1"
    echo "===================="
    echo
}

readme () {
echo <<EOF
    REMINDER:
    - Don't forget to run `chsh -s $(which zsh)` to set zsh as your default shell
    - You should probably reboot now ! just to be sure
EOF
}
