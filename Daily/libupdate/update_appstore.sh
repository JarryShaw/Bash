#!/bin/bash


################################################################################
# Check software updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Outdated Flag
################################################################################


# Preset Terminal Output Colours
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $2 ]] ; then
    echo "-*- ${color}App Store${reset} -*-"
    echo ;

    # if no outdated packages found
    if ( ! $3 ) ; then
        echo "${green}All applications have been up-to-date.${reset}"
        exit 0
    fi

    quiet="set -x"
    regex=""
else
    # if no outdated packages found
    if ( ! $3 ) ; then
        exit 0
    fi

    quiet=":"
    regex=" | grep -v \"\""
fi


# All or Specified Packages
case $1 in
    "all")
        ( $quiet; sudo softwareupdate --no-scan --install --all $regex; )
        if [[ -z $2 ]] ; then
            echo ;
        fi ;;
    *)
        ( $quiet; sudo softwareupdate --install $1 $regex; )
        if [[ -z $2 ]] ; then
            echo ;
        fi ;;
esac
