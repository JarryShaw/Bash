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
    qflg="set -x"
    if ( ! $3 ) ; then
        echo "${green}All applications have been up-to-date.${reset}"
        exit 0
    fi
else
    qflg=":"
fi


# All or Specified Packages
case $1 in
    "all")
        ( $qflg; sudo softwareupdate --no-scan --install --all; )
        echo ;;
    *)
        ( $qflg; sudo softwareupdate --install $1; )
        echo ;;
esac
