#!/bin/bash


# clear potential terminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


################################################################################
# Clean up caches.
#
# Parameter List:
#   1. Homebrew Flag
#   2. Caskroom Flag
#   3. Quiet Flag
#   4. Verbose Flag
#   5. Log Date
################################################################################


# parameter assignment
arg_brew=$1
arg_cask=$2
arg_q=$3
arg_v=$4
logdate=$5


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
if ( $arg_q ) ; then
    logcattee="tee -a $tmpfile"
    logsuffix="grep '.*'"
else
    logcattee="tee -a $tmpfile"
    logsuffix="grep -v '.*'"
fi


# if quiet flag set
if ( $arg_q ) ; then
    quiet="--quiet"
    cmd_q="-q"
else
    quiet=""
    cmd_q=""
fi


# if verbose flag not set
if ( $arg_v ) ; then
    verbose="--verbose"
    cmd_v="-v"
else
    verbose=""
    cmd_v=""
fi


# brew prune
$logprefix echo "+ brew prune $verbose $quiet" | $logcattee | $logsuffix
$logprefix brew prune $verbose $quiet | $logcattee | $logsuffix
$logprefix echo | $logcattee | $logsuffix


# archive caches if hard disk attached
if [ -e /Volumes/Jarry\ Shaw/ ] ; then
    # move caches
    $logprefix echo "+ cp -rf cache archive $verbose $quiet" | $logcattee | $logsuffix
    $logprefix cp -rf $cmd_v $(brew --cache) /Volumes/Jarry\ Shaw/Developers/ | $logcattee | $logsuffix
    $logprefix echo | $logcattee | $logsuffix

    # if cask flag set
    if ( $arg_cask ) ; then
        $logprefix echo "+ brew cask cleanup $verbose $quiet" | $logcattee | $logsuffix
        $logprefix brew cask cleanup $verbose | $logcattee | $logsuffix
        $logprefix echo | $logcattee | $logsuffix
    fi

    # if brew flag set
    if ( $arg_brew ) ; then
        | $logcattee | $logsuffix echo "+ brew cleanup $verbose $quiet" | $logcattee | $logsuffix
        $logprefix rm -rf $cmd_v $( brew --cache ) | $logcattee | $logsuffix
        $logprefix echo | $logcattee | $logsuffix
    fi
fi


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
