# vi: set ft=fish :

# eza (better ls)
alias ls "eza --color always --icons"
alias la "ls -a"
alias lla "ls -la"

alias tv tidy-viewer
alias cat "bat --no-pager"

alias clear "/usr/bin/clear && fish_greeting"
alias qbtui "qbittorrentui -c ~/.config/qbtui/config.ini"

alias wn "tn workshop"

alias ollama "docker exec -it ollama ollama"
alias t "sesh connect (sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt=' ')"
alias zid "eza -D | xargs -I {} zoxide add {}"
alias fast "npx fast-cli --single-line"

# Credit Elijah Manor : https://youtu.be/K1FxGIG_lcA
alias v "fd --type f --hidden --exclude .git --exclude node_modules --exclude cache --exclude log | fzf-tmux -p --reverse --preview 'bat -p --color=always {}' | xargs -r nvim"

abbr c clear

abbr n xdg-open
abbr n. "xdg-open ."

abbr p1 "ping 1.1.1.1"
abbr p8 "ping 8.8.8.8"

abbr k kubectl
abbr mk make
abbr sc "sudo systemctl"
abbr scu "systemctl --user"
abbr sync "~/.config/yadm/packages.d/sync-packages"

source ~/.config/fish/conf.d/aliases.d/docker-compose.fish
source ~/.config/fish/conf.d/aliases.d/git.fish
source ~/.config/fish/conf.d/aliases.d/yadm.fish
