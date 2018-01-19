#!/bin/bash


################################################################################
# Check Caskroom updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Outdated Flag
################################################################################


# The following function of Caskroom upgrade credits to
#     @Atais from <apple.stackexchange.com>
#
# caskroom update function usage:
#   caskupdate package [--quiet]
function caskupdate {
    cask=$1
    version=$(brew cask info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    # Verbose or Quiet
    if [[ -z $2 ]]; then
        quiet="set -x"
    else
        quiet=":"
    fi

    if [[ -z $installed ]] ; then
        echo "${red}${cask}${reset} requires ${red}update${reset}."
        ( $quiet; brew cask uninstall --force $2 $cask; )
        ( $quiet; brew cask install --force $2 $cask; )
        if [[ -z $2 ]] ; then
            echo ;
        fi
    else
        if [[ -z $2 ]] ; then
            echo "${red}${cask}${reset} is ${green}up-to-date${reset}."
            echo ;
        fi
    fi
}


# Preset Terminal Output Colours
red=`tput setaf 1`      # red
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $2 ]] ; then
    echo "-*- ${color}Caskroom${reset} -*-"
    echo ;

    # if no outdated packages found
    if ( ! $3 ) ; then
        echo "${green}All packages have been up-to-date.${reset}"
        exit 0
    fi
else
    # if no outdated packages found
    if ( ! $3 ) ; then
        exit 0
    fi
fi


# All or Specified Packages
case $1 in
    "all")
        casks=( $(brew cask list) )
        for cask in ${casks[@]} ; do
            caskupdate $cask $2
        done ;;
    *)
        flag=`brew cask list | grep -w $2`
        if [[ -nz $flag ]] ; then
            caskupdate $1 $2
        fi ;;
esac
