#!/bin/bash

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
            echo "Global PHP container not found. Creating ..."
            docker run -dit -v $code_directory:$code_directory -v $HOME/.composer/cache:/home/app/.composer/cache --net host -w $code_directory --name $container_name pph:7.4 /bin/sh>/dev/null
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
