#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_deps () {
    yay -Syy --noconfirm --needed $@
}

install_vim () {
    if [ ! -x "$(command -v neovim)" ]; then
        echo "Installing neovim"
        install_deps neovim ripgrep
    fi
}

install_astronvim () {
    if [ ! -d "$HOME/.config/astronvim" ]; then
        echo "Installing AstroNvim"
        git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/astronvim
        ln -s ~/.config/user-nvim/astronvim ~/.config/astronvim/lua/user
        install_deps bottom lazygit
        nvim --headless -c 'quitall'
    fi
}

install_nvchad () {
    if [ ! -d "$HOME/.config/nvchad" ]; then
        echo "Installing NvChad"
        git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/nvchad
        ln -s ~/.config/user-nvim/nvchad ~/.config/nvchad/lua/custom
        nvim-chad +NvChadUpdate +MasonInstallAll
    fi
}

update_vim_plugins () {
    nvim-astro +AstroUpdatePackages +qa
    nvim-chad +NvChadUpdate +MasonInstallAll
}

set_default_neovim_config () {
    ask "Set default NeoVim config to (astronvim/nvchad)" "a/n"

    if [[ $REPLY = "a" ]]; then
        ln -s ~/.config/astronvim ~/.config/nvim
    elif [[ $REPLY = "n" ]]; then
        ln -s ~/.config/nvchad ~/.config/nvim
    fi
}

clear_neovim_cache () {
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
}

configure_vim () {
    install_vim
    clear_neovim_cache
    install_astronvim
    install_nvchad
    set_default_neovim_config
}

vim_main () {
    section "NeoVIM"
    ask "Install/Update neovim"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ -d "$HOME/.config/nvim" ]; then
            update_vim_plugins
        else
            configure_vim
        fi
    fi
}
