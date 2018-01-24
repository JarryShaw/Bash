#!/bin/bash


# clear potential ternminal buffer
sript -q /dev/null clear > /dev/null 2>&1 | tee /dev/null


# preset terminal output colours
blush=`tput setaf 1`    # blush / red
green=`tput setaf 2`    # green
reset=`tput sgr0`       # reset


################################################################################
# Check Atom updates.
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
arg_opkg=${*:6}


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

    # if no outdated packages found
    if ( ! $arg_o ) ; then
        exit 0
    fi
else
    quiet=""

    # if no outdated packages found
    if ( ! $arg_o ) ; then
        echo "${green}All packages have been up-to-date.${reset}"
        exit 0
    fi
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
        # parameters since fourth are outdated packages
        for name in $arg_opkg ; do
            eval $logprefix echo -e "+ apm upgrade $name $verbose $quiet" $seperator $logsuffix
            eval $logprefix apm upgrade $name $verbose $quiet $seperator $logsuffix
            eval $logprefix echo $seperator $logsuffix
        done ;;
    *)
        flag=`apm list --bare --no-color | sed "s/@.*//" | awk "/^$arg_pkg$/"`
        if [[ -nz $flag ]] ; then
            eval $logprefix echo -e "+ apm upgrade $arg_pkg $verbose $quiet" $seperator $logsuffix
            eval $logprefix apm upgrade $arg_pkg $verbose $quiet $seperator $logsuffix
            eval $logprefix echo $seperator $logsuffix
        else
            eval $logprefix echo "${blush}No package names $arg_pkg installed.${reset}" $seperator $logsuffix

            # did you mean
            dym=`apm list --bare --no-color | sed "s/@.*//" | grep $arg_pkg | xargs | sed "s/ /, /g"`
            if [[ -nz $dym ]] ; then
                eval $logprefix echo "Did you mean any of the following packages: $dym?" $seperator $logsuffix
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
