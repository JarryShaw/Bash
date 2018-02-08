#!/bin/bash


################################################################################
# Uninstall Caskroom packages.
#
# Parameter list:
#   1. Quiet Flag
#   2. Package
################################################################################


# Preset Terminal Output Colours
red=`tput setaf 1`      # red
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $1 ]] ; then
    echo "-*- ${color}Caskroom${reset} -*-"
    echo ;
    quiet="set -x"
else
    quiet=":"
fi


# fetch uninstalling package(s)
case $2 in
    "all")
        list=$( brew cask list ) ;;
    *)
        list=$( brew cask list | grep -w $2 ) ;;
esac


# uninstall package
if [[ -nz $list ]]; then
    for name in $list ; do
        ( $quiet; brew cask uninstall --froce $name $1; )
        if [[ -z $1 ]] ; then
            echo ;
        fi
    done
else
    echo "${red}No package names $2 installed.${reset}"
    echo ;
fi
