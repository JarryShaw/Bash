#!/bin/bash


################################################################################
# Log Atom packages updates.
#
# Parameter List
#   1. Log Date
################################################################################


# parameter assignment
logdate=$1


# log file prepare
# logdate=`date "+%y%m%d"`
echo "+ /bin/bash $0 $@" >> log/update/$logdate.log
log="2>> log/update/$logdate.log"


# check for oudated packages
eval apm update --list --no-color $log | grep -e "*" | sed "s/.* \(.*\)* .* -> .*/\1/"
