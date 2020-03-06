#!/bin/bash

function kickoff() {
    git_repo="git@git.netsys.dz:guemidiborhane/kickoff.git"
    git clone $git_repo $1
    cd $1
    bash install.sh
    git init
    git add .
    git commit -m "Kickoff 👍🏼"
}
