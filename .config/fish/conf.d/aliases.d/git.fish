# vim ft=fish
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
