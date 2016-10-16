export ZSH=/home/$USER/.oh-my-zsh

if [[ ! $TERM =~ screen ]]; then exec tmux new-session -As $USERNAME; fi

ZSH_THEME="beardie"

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(sudo git git-flow rails)

source $ZSH/oh-my-zsh.sh

export rvmsudo_secure_path=1

export EDITOR='vim'

# source /etc/zsh_command_not_found
# [[ -e $HOME/Sources/undistract-me/notifyosd.zsh ]] && . $HOME/Sources/undistract-me/notifyosd.zsh

[[ -e $HOME/.aliases ]] && source $HOME/.aliases
[[ -f "$HOME/.bin/zap.sh" ]] && source "$HOME/.bin/zap.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# ORACLE
export LD_LIBRARY_PATH="/usr/local/lib:/opt/oracle/instantclient_11_2"
export NLS_LANG="FRENCH_FRANCE.AL32UTF8"
export JAVA_HOME="/usr/java/jdk1.8.0_101"

# PATHS
export PATH="$PATH:$HOME/.bin:$HOME/.npm-global/bin:$HOME/.config/composer/vendor/bin:$LD_LIBRARY_PATH:$HOME/.fasta"
export NODE_PATH="$NODE_PATH:$HOME/.npm-global/lib/node_modules"
