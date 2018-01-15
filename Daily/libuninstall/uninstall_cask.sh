#!/bin/bash


color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Uninstall Caskroom packages.
################################################################################


echo "-*- ${color}Caskroom${reset} -*-"

case $2 in
    "all")
        list=$( brew cask list ) ;;
    *)
        list=$2 ;;
esac

for pkg in $list ; do
    ( set -x; brew cask uninstall --froce $1 $pkg; )
done
