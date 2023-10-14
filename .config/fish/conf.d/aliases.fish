# vi: set ft=fish :

abbr c "clear"
abbr n "xdg-open"
abbr n. "xdg-open ."
# abbr code "cd ~/Code"

abbr sshkey "xclip -sel clip < ~/.ssh/id_ed25519.pub && notify-send -t 1000 -i ~/.icons/key_ok.png 'Public Key copied to clipboard'"
abbr sshconfig "vim ~/.ssh/config"

set -x EDITOR "nvim"
abbr fishrc "$EDITOR ~/.config/fish/config.fish"
abbr aliases "$EDITOR ~/.config/fish/conf.d/aliases.fish"

abbr uu "yay -Syyu --noconfirm"
abbr clip "xclip -sel clip"
abbr cpwd "pwd | clip"
abbr wtr "curl -s wttr.in | head -7"

# lsd
abbr ls "lsd"
abbr la "ls -a"
abbr lla "ls -la"

# Git aliases
set -x INITIAL_COMMIT_MSG "The same thing we do every night, Pinky - try to take over the world!"
set -x BATMAN_INITIAL_COMMIT_MSG "Batman! (this commit has no parents)"

abbr nah "git reset --hard;git clean -df"
abbr oops "git commit --amend --no-edit"
abbr gaa "git add ."
abbr gac "git add . && git commit -m"
abbr gc "git commit -m"
abbr gs "git status"
abbr gd "git diff"
abbr s "git st"
abbr push "git push"
abbr p "push"
abbr gpf "git push -f"
abbr glog "git lg"
abbr amend "env HUSKY=0 git commit --amend"

# docker-compose
abbr dc docker-compose
abbr dcup "dc up"
abbr dcupd "dc up -d"
abbr dcdn "dc down"
abbr dce "dc exec"
abbr dclf "dc logs -f"
abbr dcps "dc ps"

abbr sudo doas
abbr sudoedit "sudo vim"

abbr tv tidy-viewer
abbr cat bat --no-pager
abbr mc mcli

abbr p1 "ping 1.1.1.1"
abbr p8 "ping 8.8.8.8"

# kubectl
abbr k kubectl
