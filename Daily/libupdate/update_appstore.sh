#!/bin/bash


color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Check software updates.
################################################################################


echo "-*- ${color}App Store${reset} -*-"

case $2 in
    "all")
        ( set -x; sudo softwareupdate --no-scan --install --all; ) ;;
    *)
        ( set -x; sudo softwareupdate --install $2; ) ;;
esac
