#!/bin/bash


# clear potential terminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


# Preset Terminal Output Colours
blush="tput setaf 1"    # blush / red
green="tput setaf 2"    # green
reset="tput sgr0"       # reset


################################################################################
# Check Homebrew updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Verbose Flag
#   4. Log Date
#   5. Outdated Flag
#   6. Outdated Packages
#       ............
################################################################################


# parameter assignment
arg_pkg=$1
arg_q=$2
arg_v=$3
logdate=$4
arg_o=$5
arg_opkg=${*:76}


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
else
    quiet=""
fi


# if no outdated packages found
if ( ! $arg_o ) ; then
    $logprefix echo "${green}All packages have been up-to-date.${reset}" | $logcattee | $logsuffix
    exit 0
fi


# if verbose flag set
if ( $arg_v ) ; then
    verbose="--verbose"
else
    verbose=""
fi


# All or Specified Packages
case $arg_pkg in
    "all")
        for name in $arg_opkg ; do
            $logprefix echo "+ brew upgrade $name --cleanup $verbose $quiet" | $logcattee | $logsuffix
            $logprefix brew upgrade $name --cleanup $verbose $quiet | $logcattee | $logsuffix
            $logprefix echo | $logcattee | $logsuffix
        done ;;
    *)
        flag=`brew list -1 | awk "/^$arg_pkg$/"`
        if [[ -nz $flag ]] ; then
            $logprefix echo "+ brew upgrade $arg_pkg --cleanup $verbose $quiet" | $logcattee | $logsuffix
            $logprefix brew upgrade $arg_pkg --cleanup $verbose $quiet | $logcattee | $logsuffix
            $logprefix echo | $logcattee | $logsuffix
        else
            $blush
            $logprefix echo "No package names $arg_pkg installed." | $logcattee | $logsuffix
            $reset

            # did you mean
            dym=`brew list -1 | grep $arg_pkg | xargs | sed "s/ /, /g"`
            if [[ -nz $dym ]] ; then
                $logprefix echo "Did you mean any of the following packages: $dym?" | $logcattee | $logsuffix
            fi
        fi ;;
esac


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
