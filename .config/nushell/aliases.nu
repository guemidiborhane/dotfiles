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

# Utilities
alias tv = tidy-viewer
alias cat = bat --no-pager
alias ollama = docker exec -it ollama ollama
alias qbtui = qbittorrentui -c ~/.config/qbtui/config.ini
alias wn = tn workshop
alias fast = npx fast-cli --single-line
alias speedtest = fast

alias _k = kubectl
# ping
alias _p1 = ping 1.1.1.1
alias _p8 = ping 8.8.8.8

# aliases that start with _ are treated like abbr in fish
alias _ye = yadm edit
alias _yu = yadm pull
alias _yp = yadm push
alias _gg = yadm_lazygit
alias _yn = yadm enter nvim
alias _ys = yadm st
alias _sc = systemctl
alias _scu = systemctl --user

