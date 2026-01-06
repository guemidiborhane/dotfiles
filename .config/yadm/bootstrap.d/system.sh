#!/usr/bin/env sh
# vim: set ft=sh sw=4 et :

configure_backlight_udev_rule () {
sudo tee /etc/udev/rules.d/90-backlight.rules &>/dev/null <<EOF
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"
EOF
    sudo usermod -aG video $USER
}

configure_backlight () {
    ask "Configure backlight"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        configure_backlight_udev_rule
    fi
}

configure_resolvconf () {
    ask "Configure resolvconf"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        _configure_resolvconf
    fi
}

