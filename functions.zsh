#!/bin/bash

function pagespeed() {
    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{http_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $1
}

function kickoff() {
    git_repo="git@git.netsys.dz:guemidiborhane/kickoff.git"
    git clone $git_repo $1
    cd $1
    bash install.sh
    git init
    git add .
    git commit -m "Kickoff 👍🏼"
}

function dokku() {
    ssh paas.netsys.arpa -t -- "${@:1}"
}
