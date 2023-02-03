#!/bin/sh
# vim: set ft=sh sw=4 et :

ask () {
    if [ "$INSTALL_ALL" = "yes" ]; then
        return 0
    fi

    valid_answers="y/N"

    if [ ! -z "$2" ]; then
        valid_answers="$2"
    fi

    read -p "$1? [$valid_answers] " -n 1 -r
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
    echo "REMINDER:
- Don't forget to run \`chsh -s \$\(which zsh\)\` to set zsh as your default shell
- You should probably reboot now ! just to be sure"
}
