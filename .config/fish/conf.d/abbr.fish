# vi: set ft=fish :

abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"
abbr rmi "rm -iv"

abbr c clear
abbr n xdg-open
abbr n. "xdg-open ."
abbr p1 "ping 1.1.1.1"
abbr p8 "ping 8.8.8.8"
abbr --position anywhere vim nvim
abbr uu update_all
abbr pp fish -P
abbr hr hyprctl reload
abbr tp tmux_popup
abbr watch "watch -d -n 10"

abbr prod 'kubectl --context elhakim'
abbr stage 'kubectl --context benboulaid'

set dc docker-compose
abbr dc $dc
abbr dcb "$dc build"
abbr dcup "$dc up"
abbr dcupd "$dc up -d"
abbr dcdn "$dc down"
abbr dce "$dc exec"
abbr dclf "$dc logs -f"
abbr dcps "$dc ps"

abbr k kubectl
abbr ke kubectl edit
abbr kg kubectl get

set mk make
abbr mk $mk
abbr mkc "$mk console"
abbr mkf "$mk fish"
abbr mkd "$mk dev"
abbr mkdd "$mk down"
abbr mkr "$mk restart"
abbr mktt "$mk test"

abbr sc "sudo systemctl"
abbr scu "systemctl --user"
abbr jf "journalctl -fu"
abbr jfu "journalctl --user -fu"

abbr ye "yadm edit"
abbr yu "yadm pull --rebase"
abbr yp "yadm push"
abbr yn "yadm enter nvim"
abbr ys "yadm st"
abbr yg "tmux_popup -w 90% -h 90% yadm enter lazygit"

abbr s "nix-shell -p"
abbr ss "nh search"
abbr nos "nh os switch"
abbr yy "sudo nix flake update && nos"

abbr jms "dr --unit=jellyfin-mpv -- /usr/bin/jellyfin-mpv-shim --config ~/.config/mpv"
