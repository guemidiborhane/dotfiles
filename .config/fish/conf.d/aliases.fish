# vi: set ft=fish :
status is-interactive; or exit

abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"

# source: https://denshub.com/en/best-ls-command-alternative/#first-time
alias ls 'eza --color=always --icons=auto --group-directories-first'
alias ld 'ls -lD'
alias lf 'ls -lF'
alias ll 'ls -al'
alias lt 'ls -al --sort=modified'

alias tv tidy-viewer
alias cat "bat --no-pager"

alias clear "/usr/bin/clear && fish_greeting"
alias qbtui "qbittorrentui -c ~/.config/qbtui/config.ini"

alias wn "tn workshop"

alias ollama "docker exec -it ollama ollama"
alias t "sesh connect (sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt=' ')"
alias zid "eza -D | xargs -I {} zoxide add {}"
alias fast "bunx -- fast-cli --single-line"

# Credit Elijah Manor : https://youtu.be/K1FxGIG_lcA
alias v "fd --type f --hidden --exclude .git --exclude node_modules --exclude cache --exclude log | fzf-tmux -p --reverse --preview 'bat -p --color=always {}' | xargs -r nvim"

alias which "type -a"

abbr c clear

abbr n xdg-open
abbr n. "xdg-open ."

abbr p1 "ping 1.1.1.1"
abbr p8 "ping 8.8.8.8"

abbr k kubectl
abbr sc "sudo systemctl"
abbr scu "systemctl --user"
abbr --position anywhere vim nvim
abbr --position anywhere tp tmux_popup
abbr y yay
abbr s yay -Sy
abbr ss yay -Ss
abbr uu update_all
abbr b btop
abbr pp fish -P
abbr hr hyprctl reload

alias tk 'tmux_popup tmux_kill'

source ~/.config/fish/conf.d/aliases.d/docker-compose.fish
source ~/.config/fish/conf.d/aliases.d/git.fish
source ~/.config/fish/conf.d/aliases.d/make.fish
source ~/.config/fish/conf.d/aliases.d/yadm.fish
source ~/.config/fish/conf.d/aliases.d/yay.fish
source ~/.config/fish/conf.d/aliases.d/systemd.fish
