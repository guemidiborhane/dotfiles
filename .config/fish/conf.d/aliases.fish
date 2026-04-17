# vi: set ft=fish :
alias wn "tn workshop"

status is-interactive; or exit

# source: https://denshub.com/en/best-ls-command-alternative/#first-time
alias ls 'eza --color=auto --icons=auto --group-directories-first'
alias ld 'ls -lD'
alias lf 'ls -lF'
alias ll 'ls -al'
alias lt 'ls -al --sort=modified'

alias cat "bat --no-pager"
alias clear "command clear && fish_greeting"
alias qbtui "qbittorrentui -c ~/.config/qbtui/config.ini"
alias zid "eza -D | xargs -I {} zoxide add {}"
alias fast "bunx -- fast-cli --single-line"
# Credit Elijah Manor : https://youtu.be/K1FxGIG_lcA
alias v "fd --type f | fzf-tmux -p --reverse --preview 'bat -p --color=always {}' | xargs -r nvim"
alias vi $EDITOR
alias vim $EDITOR

alias t sesh-connect

alias which "type -a"
alias gzip pigz
alias tv tidy-viewer

set -x INITIAL_COMMIT_MSG "The same thing we do every night, Pinky - try to take over the world!"
set -x BATMAN_INITIAL_COMMIT_MSG "Batman! (this commit has no parents)"

abbr nah "git reset --hard;git clean -df"
abbr oops "git commit --amend --no-edit"
abbr gaa "git add ."
abbr gac "git add . && git commit -m"
abbr gc "git commit -m"
abbr gco "git checkout"
abbr gcd "git checkout develop"
abbr gcm "git checkout master"
abbr gs "git st"
abbr gd "git diff"
abbr push "git push"
abbr p push
abbr gpf "git push -f"
abbr glog "git lg"
abbr amend "env HUSKY=0 git commit --amend"

alias sr steam-run
