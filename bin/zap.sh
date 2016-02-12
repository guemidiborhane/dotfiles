#!/bin/bash

function zap() {
    USAGE="Usage: zap [remember|to|forget|list] [bookmark]" ;
    if  [ ! -e ~/.bookmarks ] ; then
        mkdir ~/.bookmarks
    fi

    case $1 in
        # create bookmark
        remember) shift
            if [ ! -f ~/.bookmarks/$1 ] ; then
                echo "cd `pwd`" > ~/.bookmarks/"$1" ;
                echo "OK, I'll remember it." ;
            else
                echo "There is already a bookmark named '$1'."
            fi
            ;;
        # goto bookmark
        to) shift
            if [ -f ~/.bookmarks/$1 ] ; then
                source ~/.bookmarks/"$1"
            else
                echo "This bookmark's location has been lost to the void." ;
            fi
            ;;
        # delete bookmark
        forget) shift
            if [ -f ~/.bookmarks/$1 ] ; then
                rm ~/.bookmarks/"$1" ;
                echo "The '$1' bookmark has been forgotten." ;
            else
                echo "I can't find a bookmark with that name." ;
            fi
            ;;
        # list bookmarks
        list) shift
            ls -l ~/.bookmarks/ ;
            ;;
         *) echo "$USAGE" ;
            ;;
    esac
}

_zap()
{
  compadd $(ls -1 ~/.bookmarks/)
}

compdef _zap zap
