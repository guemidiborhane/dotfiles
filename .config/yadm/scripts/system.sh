#!/bin/sh
# vim: set ft=sh sw=4 et :

configure_resolvconf () {
sudo tee /etc/NetworkManager/conf.d/10-dns-none.conf &>/dev/null <<EOF
    [main]
    dns=none
EOF
sudo tee /etc/resolvconf.conf &>/dev/null <<EOF
    nameserver 127.0.0.1
    nameserver 1.1.1.1
    nameserver 1.0.0.1
    # NOTE: the libc resolver may not support more than 3 nameservers.
    # The nameservers listed below may not be recognized.
    nameserver 2111:3c:123:0:c:135:9a:a15
    nameserver 2111:3c:123:0:3bc6:a:9cc:518
EOF
    sudo resolvconf -u
    sudo systemctl restart NetworkManager
}

enable_system_services () {
sudo sh -c <<EOF
    systemctl enable --now bluetooth
    systemctl enable --now fstrim.timer
    systemctl enable --now ntpd.service
EOF
}
