#!/bin/bash


# preset terminal output colours
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


################################################################################
# Clean up caches.
#
# Parameter List:
#   1. Homebrew Flag
#   2. Caskroom Flag
#   3. Quiet Flag
#   4. Verbose Flag
################################################################################


# parameter assignment
arg_brew=$1
arg_cask=$2
arg_q=$3
arg_v=$4


# if quiet flag not set
if [[ -z $arg_q ]] ; then
    echo "-*- ${color}Cleanup${reset} -*-"
    echo ;
    quiet="set -x"
    regex=""
else
    quiet=":"
    regex=" | grep -v \"\""
fi


# if verbose flag not set
if [[ -z $arg_v ]] ; then
    verbose=''
else
    verbose='-v'
fi


# brew prune
( $quiet; brew prune $arg_v $regex; )
echo ;


# archive caches if hard disk attached
if [ -e /Volumes/Jarry\ Shaw/ ] ; then
    if [[ -z $arg_q ]] ; then
        echo "+ cp -rf cache archive $arg_v"
        cp -rf $verbose $(brew --cache) /Volumes/Jarry\ Shaw/Developers/;
        echo ;
    fi

    if ( $arg_brew ) ; then
        ( $quiet; brew cleanup $arg_v $regex; )
        echo ;
    fi

    if ( $arg_cask ) ; then
        ( $quiet; brew cask cleanup $arg_v $regex; )
        echo ;
    fi
fi
