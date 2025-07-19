#!/bin/sh
# vim: set ft=sh sw=4 et :

_configure_resolvconf () {
sudo tee /etc/NetworkManager/conf.d/10-dns-none.conf &>/dev/null <<EOF
[main]
dns=none
EOF
sudo -s <<EOF
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved.service
systemctl restart NetworkManager
EOF
sudo tee /etc/resolv.conf &>/dev/null <<EOF
# bootstraped by yadm
nameserver 127.0.0.1
nameserver 1.1.1.1
nameserver 1.0.0.1
EOF
}

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

enable_system_services () {
    ask "Enable system services"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo systemctl enable --now $@
    fi
}
