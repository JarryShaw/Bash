#!/bin/bash


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
# logdate=`date "+%y%m%d"`
echo "" >> log/update/$logdate.log
echo "+ /bin/bash $0 $@" >> log/update/$logdate.log
logprefix="script -q /dev/null"
if ( $arg_q ) ; then
    logsuffix=">> /tmp/update.log"
else
    logsuffix=" | tee -a /tmp/update.log"
fi
logcatsed='grep "[[0-9][0-9]*m" /tmp/update.log | sed "s/^/ERR: /" | sed "s/\[[0-9][0-9]*m//g" >> log/update/$logdate.log'


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
        if ( ! $arg_q ) ; then
            echo "softwareupdate --install --no-scan --all $verbose $quiet"
        fi
        eval $logprefix sudo -H softwareupdate --install --no-scan --all $verbose $quiet $logsuffix
        eval $logcatsed
        if ( ! $arg_q ) ; then
            echo ;
        fi ;;
    *)
        installed='find /Applications -path "*Contents/_MASReceipt/receipt" -maxdepth 4 -print | sed "s#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##"'
        flag=`eval $installed | sed "s/.app//" | awk "/^$arg_pkg$/"`
        if [[ -nz $flag ]] ; then
            if ( ! $arg_q ) ; then
                echo -e "softwareupdate --install --no-scan $arg_pkg $verbose $quiet"
            fi
            eval $logprefix sudo -H softwareupdate --install --no-scan $arg_pkg $verbose $quiet $logsuffix
            eval $logcatsed
            if ( ! $arg_q ) ; then
                echo ;
            fi
        else
            echo -e "${blush}No application names $arg_pkg installed.${reset}"

            # did you mean
            dym=`eval $installed | sed "s/.app//" | grep $arg_pkg | xargs | sed "s/ /, /g"`
            if [[ -nz $dym ]] ; then
                echo "Did you mean any of the following applications: $dym?"
            fi
        fi ;;
esac
