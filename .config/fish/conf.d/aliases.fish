# vi: set ft=fish :
alias wn "tn workshop"

status is-interactive; or exit

# source: https://denshub.com/en/best-ls-command-alternative/#first-time
alias ls 'eza --color=always --icons=auto --group-directories-first'
alias ld 'ls -lD'
alias lf 'ls -lF'
alias ll 'ls -al'
alias lt 'ls -al --sort=modified'

alias cat "bat --no-pager"
alias clear "/usr/bin/clear && fish_greeting"
alias qbtui "qbittorrentui -c ~/.config/qbtui/config.ini"
alias ollama "docker exec -it ollama ollama"
alias zid "eza -D | xargs -I {} zoxide add {}"
alias fast "bunx -- fast-cli --single-line"
# Credit Elijah Manor : https://youtu.be/K1FxGIG_lcA
alias v "fd --type f | fzf-tmux -p --reverse --preview 'bat -p --color=always {}' | xargs -r nvim"

alias tk 'tmux_popup tmux_kill'
alias t "sesh connect (sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt=' ')"

alias which "type -a"
alias gzip pigz
alias yeet "yay -Rncs"
alias tv tidy-viewer

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
alias push "git push"
alias p push
alias gpf "git push -f"
alias glog "git lg"
alias amend "env HUSKY=0 git commit --amend"

abbr elhakim 'kubectl --context elhakim'
abbr benboulaid 'kubectl --context benboulaid'
