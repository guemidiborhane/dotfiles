# vi: set ft=fish :

abbr c "clear"
abbr n "xdg-open"
abbr n. "xdg-open ."
# abbr code "cd ~/Code"

abbr sshkey "xclip -sel clip < ~/.ssh/id_ed25519.pub && notify-send -t 1000 -i ~/.icons/key_ok.png 'Public Key copied to clipboard'"
abbr sshconfig "vim ~/.ssh/config"

set -x EDITOR "nvim"
alias fishrc "$EDITOR ~/.config/fish/config.fish"
abbr aliases "$EDITOR ~/.config/fish/conf.d/aliases.fish"

abbr uu "yay -Syyu --noconfirm"
abbr clip "xclip -sel clip"
alias cpwd "pwd | clip"
abbr wtr "curl -s wttr.in | head -7"

# lsd
alias ls "lsd"
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
alias gs "git status"
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

alias sudo doas
abbr sudoedit "sudo vim"

alias tv tidy-viewer
alias cat "bat --no-pager"
abbr mc mcli

abbr p1 "ping 1.1.1.1"
abbr p8 "ping 8.8.8.8"

# kubectl
abbr k kubectl
