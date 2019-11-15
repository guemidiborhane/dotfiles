export ZSH=/home/$USER/.oh-my-zsh

# if [[ ! $TERM =~ screen ]]; then exec tmux new-session -As $USERNAME; fi

# ZSH_THEME="refined"
ZSH_THEME="spaceship"

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(sudo git)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

# source /etc/zsh_command_not_found
# [[ -e $HOME/Sources/undistract-me/notifyosd.zsh ]] && . $HOME/Sources/undistract-me/notifyosd.zsh

[[ -e $HOME/.aliases ]] && source $HOME/.aliases
[[ -f "$HOME/.bin/zap.sh" ]] && source "$HOME/.bin/zap.sh"

# ORACLE
export LD_LIBRARY_PATH="/usr/local/lib:/opt/oracle/instantclient_11_2"
export NLS_LANG="FRENCH_FRANCE.AL32UTF8"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle/"

# PATHS
export PATH="$PATH:$HOME/.bin:$(yarn global bin):$HOME/.config/composer/vendor/bin:$LD_LIBRARY_PATH:$HOME/.fasta"
export NODE_PATH="$NODE_PATH:$HOME/.npm-global/lib/node_modules"

source ~/.bin/tmuxinator.zsh
# eval "$(thefuck --alias)"

export rvmsudo_secure_path=1
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export ANDROID_HOME=$HOME/Android/Sdk
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

export GEOSERVER_HOME=$HOME/Code/geoserver
export SPACESHIP_BATTERY_SHOW=false
