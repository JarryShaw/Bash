#!/bin/bash


################################################################################
# Log Homebrew packages updates.
#
# Parameter list:
#   1. Quiet Flag
#   2. Verbose Flag
################################################################################


# parameter assignment
arg_q=$1
arg_v=$2


# if verbose flag not set
if [[ -z $arg_v ]] ; then
    verbose=""
else
    verbose="--force"
fi


# if quiet flag not set
if [[ -z $arg_q ]] ; then
    ( set -x; brew update $verbose; )
    echo ;
else
    brew update $verbose
fi
