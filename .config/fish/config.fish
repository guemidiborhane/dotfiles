# vi: set ft=fish :

function fish_greeting
    fastfetch
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
fish_ssh_agent

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx i3 -- -keeptty
    end
end

starship init fish | source
fish_vi_key_bindings
enable_transience

