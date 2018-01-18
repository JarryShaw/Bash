#!/bin/bash


################################################################################
# Check Homebrew updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Outdated Flag
#   4. Outdated Packages
#   ............
################################################################################


# Preset Terminal Output Colours
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $2 ]] ; then
    echo "-*- ${color}Homebrew${reset} -*-"
    qflg="set -x"
    if ( ! $3 ) ; then
        echo "${green}All packages have been up-to-date.${reset}"
        exit 0
    fi
else
    qflg=":"
fi


# All or Specified Packages
case $1 in
    "all")
        # parameters since fourth are outdated packages
        for pkg in ${*:4} ; do
            ( $qflg; brew upgrade $pkg; )
            echo
        done ;;
    *)
        ( $qflg; brew upgrade $1; )
        echo ;;
esac
