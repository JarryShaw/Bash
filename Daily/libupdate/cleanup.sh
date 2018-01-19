#!/bin/bash


################################################################################
# Clean up caches.
#
# Parameter List:
#   1. Homebrew Flag
#   2. Caskroom Flag
#   3. Quiet Flag
################################################################################


# Preset Terminal Output Colours
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $3 ]] ; then
    echo "-*- ${color}Cleanup${reset} -*-"
    echo ;
    quiet="set -x"
    regex=""
    verbose="-v"
else
    quiet=":"
    regex=" | grep -v \"\""
    verbose="-v"
fi


# brew prune
( $quiet; brew prune $regex; )
echo ;


# archive caches if hard disk attached
if [[ -e "/Volumes/Jarry\ Shaw/" ]] ; then
    if [[ -z $3 ]] ; then
        echo "+ cp -rf cache archive --verbose"
        cp -rf $(brew --cache) /Volumes/Jarry\ Shaw/Developers/ $verbose;
        echo ;
    fi

    if ( $1 ) ; then
        ( $quiet; brew cleanup $regex; )
        echo ;
    fi

    if ( $2 ) ; then
        ( $quiet; brew cask cleanup $regex; )
        echo ;
    fi
fi
