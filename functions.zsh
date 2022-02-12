#!/bin/bash

function pagespeed() {
    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{http_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null $1
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

function _run_in_php_container() {
    if [ ! -f ./docker-compose.yml ]
    then
        container_name="php-container"
        if [ ! "$(docker ps -q -f name=$container_name)" ]
        then
            if [ "$(docker ps -aq -f status=exited -f name=$container_name)" ]
            then
                # cleanup
                docker rm $container_name
            fi
            # run your container
            code_directory="$HOME/Code"
            image_name="guemidiborhane/php-cli:latest"
            echo "Global PHP container not found. Creating ..."
            docker run -dit -v $code_directory:$code_directory -v $HOME/.composer/cache:/home/app/.composer/cache --net host -w $code_directory --name $container_name $image_name /bin/sh>/dev/null
        fi
        docker exec -it -w $(pwd) $container_name $1 "${@:2}"
    else
        service_name="php"

        if [ -z "$(docker-compose ps -q $service_name)" ]
        then
            docker-compose up -d $service_name
        fi

        docker-compose exec $service_name $1 "${@:2}"
    fi
}

alias php="_run_in_php_container php"
alias composer="_run_in_php_container composer"
