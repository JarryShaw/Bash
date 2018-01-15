#!/bin/bash


red=`tput setaf 1`
green=`tput setaf 2`
color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Check Caskroom updates.
################################################################################


echo "-*- ${color}Caskroom${reset} -*-"

# The following function of Caskroom upgrade credits to
#     @Atais from <apple.stackexchange.com>

function caskupdate {
    cask=$2
    version=$(brew cask info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    if [[ -z $installed ]] ; then
        echo "${red}${cask}${reset} requires ${red}update${reset}."
        (set -x; brew cask uninstall $cask $1 --force;); echo
        (set -x; brew cask install $cask $1 --force;); echo
    else
        if [[ -z $1 ]] ; then
            echo "${red}${cask}${reset} is ${green}up-to-date${reset}."
        fi
    fi
}

case $2 in
    "all")
        casks=( $(brew cask list) )
        for cask in ${casks[@]} ; do
            caskupdate $1 $cask
        done ;;
    *)
        flag=`brew cask list | grep -w $2`
        if [[ $flag ]] ; then
            caskupdate $1 $2
        fi ;;
esac
