#!/bin/bash


# clear potential ternminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


# Preset Terminal Output Colours
blush=`tput setaf 1`    # blush / red
green=`tput setaf 2`    # green
reset=`tput sgr0`       # reset


################################################################################
# Check software updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Verbose Flag
#   4. Log Date
#   5. Outdated Flag
################################################################################


# Parameter Assignment
arg_pkg=$1
arg_q=$2
arg_v=$3
logdate=$4
arg_o=$5


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

    # if no outdated applications found
    if ( ! $arg_o ) ; then
        exit 0
    fi
else
    quiet=""

    # if no outdated applications found
    if ( ! $arg_o ) ; then
        echo "${green}All applications have been up-to-date.${reset}"
        exit 0
    fi
fi


# All or Specified Packages
case $arg_pkg in
    "all")
        eval $logprefix echo -e "+ softwareupdate --install --no-scan --all $verbose $quiet" $seperator $logsuffix
        eval $logprefix sudo -H softwareupdate --install --no-scan --all $verbose $quiet $seperator $logsuffix
        eval $logprefix echo $seperator $logsuffix ;;
    *)
        installed="find /Applications -path \"*Contents/_MASReceipt/receipt\" -maxdepth 4 -print | sed \"s#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##\""
        flag=`eval $installed | sed "s/.app//" | awk "/^$arg_pkg$/"`
        if [[ -nz $flag ]] ; then
            eval $logprefix echo -e "+ softwareupdate --install --no-scan $arg_pkg $verbose $quiet" $seperator $logsuffix
            eval $logprefix sudo -H softwareupdate --install --no-scan $arg_pkg $verbose $quiet $seperator $logsuffix
            eval $logprefix echo $seperator $logsuffix
        else
            eval $logprefix echo "${blush}No application names $arg_pkg installed.${reset}" $seperator $logsuffix

            # did you mean
            dym=`eval $installed | sed "s/.app//" | grep $arg_pkg | xargs | sed "s/ /, /g"`
            if [[ -nz $dym ]] ; then
                eval $logprefix echo "Did you mean any of the following applications: $dym?" $seperator $logsuffix
            fi
        fi ;;
esac


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
