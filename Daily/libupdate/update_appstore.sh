#!/bin/bash


# Preset Terminal Output Colours
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


################################################################################
# Check software updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Verbose Flag
#   4. Outdated Flag
################################################################################


# Parameter Assignment
arg_pkg=$1
arg_q=$2
arg_v=$3
arg_o=$4


# if quiet flag not set
if [[ -z $arg_q ]] ; then
    # echo "-*- ${color}App Store${reset} -*-"
    # echo ;

    # if no outdated packages found
    if ( ! $arg_o ) ; then
        echo "${green}All applications have been up-to-date.${reset}"
        exit 0
    fi

    quiet="set -x"
    regex=""
else
    # if no outdated packages found
    if ( ! $arg_o ) ; then
        exit 0
    fi

    quiet=":"
    regex=" | grep -v \"\""
fi


# All or Specified Packages
case $arg_pkg in
    "all")
        ( $quiet; sudo -H softwareupdate --no-scan --install --all $arg_v $regex; )
        if [[ -z $arg_q ]] ; then
            echo ;
        fi ;;
    *)
        ( $quiet; sudo -H softwareupdate --install $arg_pkg $arg_v $regex; )
        if [[ -z $arg_q ]] ; then
            echo ;
        fi ;;
esac
