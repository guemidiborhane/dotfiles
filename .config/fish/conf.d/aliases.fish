# vi: set ft=fish :

abbr c "clear"
abbr n "xdg-open"
abbr n. "xdg-open ."

abbr sshkey "xclip -sel clip < ~/.ssh/id_ed25519.pub && notify-send -t 1000 -i ~/.icons/key_ok.png 'Public Key copied to clipboard'"
abbr sshconfig "vim ~/.ssh/config"

alias fishrc "$EDITOR ~/.config/fish/config.fish"
abbr aliases "$EDITOR ~/.config/fish/conf.d/aliases.fish"

abbr clip "xclip -sel clip"

# eza (better ls)
alias ls "eza --color always --icons"
alias la "ls -a"
alias lla "ls -la"

# Git aliases
set -x INITIAL_COMMIT_MSG "The same thing we do every night, Pinky - try to take over the world!"
set -x BATMAN_INITIAL_COMMIT_MSG "Batman! (this commit has no parents)"

alias nah "git reset --hard;git clean -df"
alias oops "git commit --amend --no-edit"
alias gaa "git add ."
alias gac "git add . && git commit -m"
alias gc "git commit -m"
alias gco "git checkout"
alias gcd "git checkout develop"
alias gcm "git checkout master"
alias gs "git st"
alias gd "git diff"
alias s "git st"
alias push "git push"
alias p "push"
alias gpf "git push -f"
alias glog "git lg"
alias amend "env HUSKY=0 git commit --amend"

# docker-compose
alias dc docker-compose
alias dcb "dc build"
alias dcup "dc up"
alias dcupd "dc up -d"
alias dcdn "dc down"
alias dce "dc exec"
alias dclf "dc logs -f"
alias dcps "dc ps"

abbr sudoedit "sudo vim"

alias tv tidy-viewer
alias cat "bat --no-pager"
abbr mc mcli

abbr p1 "ping 1.1.1.1"
abbr p8 "ping 8.8.8.8"

# kubectl
abbr k kubectl
alias k kubectl

alias ollama "docker exec -it ollama ollama"
alias t "sesh connect (sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt=' ')"
alias zid "eza -D | xargs -I {} zoxide add {}"

# Credit Elijah Manor : https://youtu.be/K1FxGIG_lcA
alias v "fd --type f --hidden --exclude .git --exclude node_modules --exclude cache --exclude log | fzf-tmux -p --reverse --preview 'bat -p --color=always {}' | xargs -r nvim"

# YADM
abbr ye "yadm edit"
abbr yu "yadm pull"
abbr yp "yadm push"
abbr yl "yadm enter lazygit"
abbr ys "yadm st"

# Systemd
abbr sc  "sudo systemctl"
abbr scu "systemctl --user"


alias clear "/usr/bin/clear && fish_greeting"
alias qbtui "qbittorrentui -c ~/.config/qbtui/config.ini"


alias wn "tn workshop"
