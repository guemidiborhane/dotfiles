#!/bin/sh
# vim: set ft=sh sw=4 et :

ask () {
    if [ "$INSTALL_ALL" = "yes" ]; then
        return 0
    fi

    read -p "$1? [y/N] " -n 1 -r
    echo   # (optional) move to a new line
}
