[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

precmd() { 
  # [[ -f $(pwd)/.project-aliases ]] && eval "source $(pwd)/.project-aliases"
  # eval "pwd > /tmp/whereami" 
}

# Change to saved working dir
[[ -f "/tmp/whereami" ]] && cd "$(< /tmp/whereami)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=/home/$USER/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="false"
COMPLETION_WAITING_DOTS="true"

plugins=(
  sudo git wd
  zsh-autosuggestions zsh-syntax-highlighting 
  docker docker-compose
  hacker-quotes
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

# source /etc/zsh_command_not_found
# [[ -e $HOME/Sources/undistract-me/notifyosd.zsh ]] && . $HOME/Sources/undistract-me/notifyosd.zsh

[[ -e $HOME/.aliases ]] && source $HOME/.aliases
[[ -f "$HOME/.bin/zap.sh" ]] && source "$HOME/.bin/zap.sh"
[[ -f "$HOME/.bin/php.sh" ]] && source "$HOME/.bin/php.sh"
[[ -f "$HOME/.bin/kickoff.sh" ]] && source "$HOME/.bin/kickoff.sh"

# PATHS
export PATH="$PATH:$HOME/.bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export OPENCV_LOG_LEVEL=ERROR

export PATH=$PATH:~/.emacs.d/bin
export JAVA_HOME="/usr/lib/jvm/default-runtime"
# source /usr/share/nvm/init-nvm.sh
source ~/.i3/gnome-keyring.sh
