export ZSH=/home/$USER/.oh-my-zsh

if [[ ! $TERM =~ screen ]]; then exec tmux new-session -As $USERNAME; fi

ZSH_THEME="beardie"

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git rails git-flow)

source $ZSH/oh-my-zsh.sh

export rvmsudo_secure_path=1

source /etc/zsh_command_not_found
# [[ -e $HOME/Sources/undistract-me/notifyosd.zsh ]] && . $HOME/Sources/undistract-me/notifyosd.zsh

[[ -e $HOME/.aliases ]] && source $HOME/.aliases
[[ -f "$HOME/.bin/zap.sh" ]] && source "$HOME/.bin/zap.sh"

# PATHS
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.npm-global/bin" # Add NPM to PATH for scripting
export PATH="$PATH:$HOME/.composer/vendor/bin" # Add Composer to PATH for scripting
export NODE_PATH="$NODE_PATH:$HOME/.npm-global/lib/node_modules"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
