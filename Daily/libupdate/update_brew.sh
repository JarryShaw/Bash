#!/bin/bash


color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Check Homebrew updates.
################################################################################


echo "-*- ${color}Homebrew${reset} -*-"

case $2 in
    "all")
        for pkg in ${*:3} ; do
            ( set -x; brew upgrade $1 $pkg; ); echo
        done ;;
    *)
        ( set -x; brew upgrade $1 $2; ); echo ;;
esac
