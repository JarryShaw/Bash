#!/bin/bash


# clear potential terminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


################################################################################
# Log Homebrew packages updates.
#
# Parameter List
#   1. Log Date
################################################################################


# parameter assignment
logdate=$1


# log file prepare
logfile="/Library/Logs/Scripts/update/$logdate.log"
tmpfile="/tmp/update.log"


# remove /tmp/update.log
rm -f $tmpfile


# create /tmp/update.log & /Library/Logs/Scripts/update/logdate.log
touch $logfile
touch $tmpfile


# log current status
echo "" >> $tmpfile
echo "- /bin/bash $0 $@" >> $tmpfile


# log commands
logprefix="script -q /dev/null"
logcattee="tee -a $tmpfile"
logsuffix="grep -v '.*'"


# check for oudated packages
echo -e "+ brew outdated --quiet" >> $tmpfile
$logprefix brew outdated --quiet | $logcattee | $logsuffix
echo >> $tmpfile


# read /tmp/update.log line by line then migrate to log file
while read -r line ; do
    # plus `+` proceeds in line
    if [[ $line =~ ^(\+\+*\ )(.*)$ ]] ; then
        echo "+$line" >> $logfile
    # minus `-` proceeds in line
    elif [[ $line =~ ^(-\ )(.*)$ ]] ; then
        echo "$line" | sed "y/-/+/" >> $logfile
    # colon `:` in line
    elif [[ $line =~ ^([[:alnum:]][[:alnum:]]*)(:)(.*)$ ]] ; then
        # log tag
        prefix=`echo $line | sed "s/\[[0-9][0-9]*m//g" | sed "s/\(.*\)*:\ .*/\1/" | cut -c 1-3 | tr "[a-z]" "[A-Z]"`
        # log content
        suffix=`echo $line | sed "s/\[[0-9][0-9]*m//g" | sed "s/.*:\ \(.*\)*.*/\1/"`
        # write to /Library/Logs/Scripts/update/logdate.log
        echo "$prefix: $suffix" >> $logfile
    # error (red/[31m) line
    elif [[ $line =~ ^(.*)(\[31m)(.*)$ ]] ; then
        # add `ERR` tag and remove special characters then write to /Library/Logs/Scripts/update/logdate.log
        echo "ERR: $line" | sed "s/\[[0-9][0-9]*m//g" >> $logfile
    # warning (yellow/[33m)
    elif [[ $line =~ ^(.*)(\[33m)(.*)$ ]] ; then
        # add `WAR` tag and remove special characters then write to /Library/Logs/Scripts/update/logdate.log
        echo "WAR: $line" | sed "s/\[[0-9][0-9]*m//g" >> $logfile
    # other colourised `[??m` line
    elif [[ $line =~ ^(.*)(\[[0-9][0-9]*m)(.*)$ ]] ; then
        # add `INF` tag and remove special characters then write to /Library/Logs/Scripts/update/logdate.log
        echo "INF: $line" | sed "s/\[[0-9][0-9]*m//g" >> $logfile
    # empty / blank line
    elif [[ $line =~ ^([[:space:]]*)$ ]] ; then
        # directlywrite to /Library/Logs/Scripts/update/logdate.log
        echo $line >> $logfile
    # non-empty line
    else
        # add `OUT` tag, remove special characters and discard flushed lines then write to /Library/Logs/Scripts/update/logdate.log
        echo "OUT: $line" | sed "s/\[\?[0-9][0-9]*[a-zA-Z]//g" | sed "/\[[A-Z]/d" | sed "/##*\ \ *.*%/d" >> $logfile
    fi
done < $tmpfile


# remove /tmp/update.log
rm -f $tmpfile


# clear potential terminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null
