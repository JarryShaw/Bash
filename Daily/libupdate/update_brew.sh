#!/bin/bash


# Preset Terminal Output Colours
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


################################################################################
# Check Homebrew updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Verbose Flag
#   4. Outdated Flag
#   5. Outdated Packages
#       ............
################################################################################


# parameter assignment
arg_pkg=$1
arg_q=$2
arg_v=$3
arg_o=$4
arg_opkg=${*:5}


# if quiet flag not set
if [[ -z $arg_q ]] ; then
    # echo "-*- ${color}Homebrew${reset} -*-"
    # echo ;

    # if no outdated packages found
    if ( ! $arg_o ) ; then
        echo "${green}All packages have been up-to-date.${reset}"
        exit 0
    fi

    quiet="set -x"
    regex=""
else
    # if no outdated packages found
    if ( ! $arg_o ) ; then
        exit 0;
    fi

    quiet=":"
    regex=" | grep -v \"\""
fi


# All or Specified Packages
case $arg_pkg in
    "all")
        # parameters since fourth are outdated packages
        for name in $arg_opkg ; do
            ( $quiet; brew upgrade $name $arg_v $arg_q $regex; )
            if [[ -z $arg_q ]] ; then
                echo ;
            fi
        done ;;
    *)
        ( $quiet; brew upgrade $arg_pkg $arg_v $arg_q $regex; )
        if [[ -z $arg_q ]] ; then
            echo ;
        fi ;;
esac
