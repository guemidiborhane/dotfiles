# vi: set ft=fish :

function fish_greeting
    fastfetch
    echo -e "\n"
end

function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end

zoxide init --cmd cd fish | source
fzf --fish | source
source /usr/share/doc/find-the-command/ftc.fish quiet

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx
    end
end

starship init fish | source
fish_vi_key_bindings
enable_transience

