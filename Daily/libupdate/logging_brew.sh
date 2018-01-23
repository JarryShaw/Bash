#!/bin/bash


################################################################################
# Log Homebrew packages updates.
#
# Parameter list:
#   1. Quiet Flag
#   2. Verbose Flag
#   3. Log Date
################################################################################


# parameter assignment
arg_q=$1
arg_v=$2
logdate=$3

# log file prepare
# logdate=`date "+%y%m%d"`
echo "+ /bin/bash $0 $@" >> log/update/$logdate.log
logprefix="script -q /dev/null"
if ( $arg_q ) ; then
    logsuffix=">> /tmp/update.log"
else
    logsuffix=" | tee -a /tmp/update.log"
fi
logcatsed='grep "[[0-9][0-9]*m" /tmp/update.log | sed "s/^/ERR: /" | sed "s/\[[0-9][0-9]*m//g" >> log/update/$logdate.log'


# if verbose flag set
if ( $arg_v ) ; then
    verbose="--verbose"
else
    verbose=""
fi


# if quiet flag not set
if ( ! $arg_q ) ; then
    echo "+ brew update --force $verbose"
fi
eval $logprefix brew update --force $verbose $logsuffix
eval $logcatsed
if ( ! $arg_q ) ; then
    echo ;
fi
