#!/bin/bash


# clear potential ternminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


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
#   5. Log Date
################################################################################


# parameter assignment
arg_brew=$1
arg_cask=$2
arg_q=$3
arg_v=$4
logdate=$5


# log file prepare
logfile="log/update/$logdate.log"
tmpfile="/tmp/update.log"


# remove /temp/update.log
rm -f $tmpfile


# create /temp/update.log & log/update/logdate.log
touch $logfile
touch $tmpfile


# log current status
echo "" >> $tmpfile
echo "- /bin/bash $0 $@" >> $tmpfile


# log commands
logprefix="script -q /dev/null"
if ( $arg_q ) ; then
    logsuffix=">> $tmpfile"
    seperator=""
else
    logsuffix="tee -a \"$tmpfile\""
    seperator="|"
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
eval $logprefix echo -e "+ brew prune $verbose $quiet" $seperator $logsuffix
eval $logprefix brew prune $verbose $quiet $seperator $logsuffix
eval $logprefix echo $seperator $logsuffix


# archive caches if hard disk attached
if [ -e /Volumes/Jarry\ Shaw/ ] ; then
    # move caches
    eval $logprefix echo -e "+ cp -rf cache archive $verbose $quiet" $seperator $logsuffix
    eval $logprefix cp -rf $cmd_v $(brew --cache) /Volumes/Jarry\ Shaw/Developers/ $seperator $logsuffix
    eval $logprefix echo $seperator $logsuffix

    # if cask flag set
    if ( $arg_cask ) ; then
        eval $logprefix echo -e "+ brew cask cleanup $verbose $quiet" $seperator $logsuffix
        eval $logprefix brew cask cleanup $verbose $seperator $logsuffix
        eval $logprefix echo $seperator $logsuffix
    fi

    # if brew flag set
    if ( $arg_brew ) ; then
        eval $seperator $logsuffix echo -e "+ brew cleanup $verbose $quiet" $seperator $logsuffix
        eval $logprefix rm -rf $cmd_v $( brew --cache ) $seperator $logsuffix
        eval $logprefix echo $seperator $logsuffix
    fi
fi


# read /temp/update.log line by line then migrate to log file
while read -r line ; do
    # plus `+` proceeds in line
    if [[ $line =~ ^(\+\+*\ )(.*)$ ]] ; then
        echo "+$line" >> $logfile
    # minus `-` proceeds in line
    elif [[ $line =~ ^(-\ )(.*)$ ]] ; then
        echo "$line" | sed "y/-/+/" >> $logfile
    # colon `:` in line
    elif [[ $line =~ ^([:alnum:][:alnum:]*)(:)(.*)$ ]] ; then
        # log tag
        prefix=`echo $line | sed "s/\[[0-9][0-9]*m//g" | sed "s/\(.*\)*:\ .*/\1/" | cut -c 1-3 | tr "[a-z]" "[A-Z]"`
        # log content
        suffix=`echo $line | sed "s/\[[0-9][0-9]*m//g" | sed "s/.*:\ \(.*\)*.*/\1/"`
        # write to log/update/logdate.log
        echo "$prefix: $suffix" >> $logfile
    # colourised `[??m` line
    elif [[ $line =~ ^(.*)(\[[0-9][0-9]*m)(.*)$ ]] ; then
        # add `ERR` tag and remove special characters then write to log/update/logdate.log
        echo "ERR: $line" | sed "s/\[[0-9][0-9]*m//g" >> $logfile
    # non-empty line
    elif [[ -nz $line ]] ; then
        # add `INF` tag, remove special characters and discard flushed lines then write to log/update/logdate.log
        echo $line | sed "s/^/INF: /" | sed "s/\[\?[0-9][0-9]*[a-zA-Z]//g" | sed "/\[[A-Z]/d" >> $logfile
    # empty line
    else
        # directly write to log/update/logdate.log
        echo $line >> $logfile
    fi
done < $tmpfile


# remove /temp/update.log
rm -f $tmpfile


# clear potential ternminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null
