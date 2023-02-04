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
options rotate timeout:1 retries:1
nameserver 127.0.0.1
nameserver 1.1.1.1
nameserver 1.0.0.1
# NOTE: the libc resolver may not support more than 3 nameservers.
# The nameservers listed below may not be recognized.
nameserver 2111:3c:123:0:c:135:9a:a15
nameserver 2111:3c:123:0:3bc6:a:9cc:518
EOF
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