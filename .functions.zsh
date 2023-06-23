#!/bin/bash

function pagespeed() {
    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{response_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $1
}

function kickoff() {
    [[ -d $1 ]] && echo "Directory $1 already exists" && return 1

    git_repo="git@git.netsys.dz:guemidiborhane/kickoff.git"
    git clone $git_repo $1
    cd $1
    bash install.sh
    code .
}

alias nvim-chad="NVIM_APPNAME=nvchad nvim"
alias nvim-astro="NVIM_APPNAME=astronvim nvim"

function nvims() {
  items=("default")
  items+=$(ls ~/.config/user-nvim | sort)
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^n "nvims\n"

function tn() {
    local session_name=${1:-$(basename $PWD)}
    tmux new-session -As "$session_name"
}

bindkey -s ^T "tn\n"

