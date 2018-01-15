#!/bin/bash


red=`tput setaf 1`
green=`tput setaf 2`
color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Uninstall Homebrew packages.
################################################################################


echo "-*- ${color}Homebrew${reset} -*-"

function brew_fixmissing {
    for $name in $2 ; do
        if [[ -z $1 ]] ; then
            ( set -x; brew install $name; ); echo
        else
            brew install $1 $name
        fi
    done
    echo "${green}Missing packages installed.${reset}"
}

for pkg in ${*:4} ; do
    ( set -x; brew uninstall --force --ignore-dependencies $1 $pkg; )
done

miss=`brew missing | sed 's/.*: \(.*\)*/\1/' | sort -u | xargs`
if [[ -nz $miss ]] ; then
    echo "Required packages found missing: ${red}${miss}${reset}"
    if ( $3 ) ; then
        brew_fixmissing $1 $miss
    else
        while true ; do
            read -p "Would you like to fix? (y/N)" yn
            case $yn in
                [Yy]* )
                    brew_fixmissing $1 $miss
                    break ;;
                [Nn]* ) : ;;
                * ) echo "Invalid choice.";;
            esac
        done
    fi
fi
