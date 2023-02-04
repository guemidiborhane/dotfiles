#!/bin/sh
# vim: set ft=sh sw=4 et :

install_sync () {
    echo "Installing MegaSync"
    curl -s https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst -o /tmp/megasync-x86_64.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/megasync-x86_64.pkg.tar.zst
    rm /tmp/megasync-x86_64.pkg.tar.zst
}

install_megacmd () {
    echo "Installing MegaCMD"
    curl -s https://mega.nz/linux/MEGAsync/Arch_Extra/x86_64/megacmd-x86_64.pkg.tar.zst -o /tmp/megacmd-x86_64.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/megacmd-x86_64.pkg.tar.zst
    rm /tmp/megacmd-x86_64.pkg.tar.zst
}

install_megatools () {
    section "MegaTools (for password manager sync mainly)"
    ask "Install MegaTools"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        install_sync
        install_megacmd
    fi
}
