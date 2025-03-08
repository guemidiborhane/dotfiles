# Git
alias gs = git status -sb
def gcc [msg: string] { git commit -m $msg }
def gac [msg: string] { git add .; git commit -m $msg }
def nah [] { git reset --hard; git clean -df }
alias oops = git commit --amend --no-edit
alias gaa = git add .
alias gco = git checkout
alias gcd = git checkout develop
alias gcm = git checkout master
alias gd = git diff
alias s = gs
alias push = git push
alias p = git push
alias gpf = git push -f
alias glog = git lg
alias amend = env HUSKY=0 git commit --amend

# Docker Compose
def dc [...args] { docker-compose ...$args }
alias dcb = docker-compose build
alias dcup = docker-compose up
alias dcupd = docker-compose up -d
alias dcdn = docker-compose down
alias dce = docker-compose exec
alias dclf = docker-compose logs -f
alias dcps = docker-compose ps

# System Tools
alias tv = tidy-viewer
alias cat = bat --no-pager
alias ollama = docker exec -it ollama ollama
alias qbtui = qbittorrentui -c ~/.config/qbtui/config.ini
alias wn = tn workshop

alias k = kubectl
# ping
alias p1 = ping 1.1.1.1
alias p8 = ping 8.8.8.8
# YADM
alias ye = yadm edit
alias yu = yadm pull
alias yp = yadm push
alias yl = yadm enter lazygit
alias yn = yadm enter nvim
alias ys = yadm st
# System Control
alias sc = systemctl
alias scu = systemctl --user
