#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_deps() {
    yay -Syy --noconfirm --needed $@
}

install_nvim() {
    if [ ! -x "$(command -v neovim)" ]; then
        echo "Installing neovim"
        install_deps neovim ripgrep fd bottom lazygit
        nvim --headless +q
    fi
}

clear_neovim_cache() {
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
}

configure_vim() {
    clear_neovim_cache
    install_nvim
}
