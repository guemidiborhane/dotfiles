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
  sudo git wd asdf
  zsh-autosuggestions zsh-syntax-highlighting command-not-found
  docker docker-compose
  hacker-quotes
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'
export SUDO_EDITOR='sudoedit'
export KUBE_EDITOR='code --wait'
export ANSIBLE_NOCOWS=1

[[ -e $HOME/.aliases ]] && source $HOME/.aliases
[[ -f "$HOME/.functions.zsh" ]] && source "$HOME/.functions.zsh"

# PATHS
export PATH="$PATH:$HOME/.local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export OPENCV_LOG_LEVEL=ERROR

export PATH=$PATH:~/.emacs.d/bin
export JAVA_HOME="/usr/lib/jvm/default-runtime"
source ~/.config/i3/scripts/gnome-keyring.sh

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="${PATH}:${HOME}/.krew/bin"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/mcli mcli

export MCFLY_RESULTS_SORT=LAST_RUN
export MCFLY_RESULTS=100
eval "$(mcfly init zsh)"
