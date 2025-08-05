function update_all
    if type -q yay
        yes | yay -Syyu
    end
    if test -e /usr/share/tmux-plugin-manager/bin/update_plugins
        /usr/share/tmux-plugin-manager/bin/update_plugins all
    end
    if type -q mise
        mise plugins update
        mise upgrade
    end
    if type -q nvim
        nvim --headless "+Lazy! update" +qa
    end
end

# vim ft=fish
