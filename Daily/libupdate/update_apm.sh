#!/bin/bash


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
            if ( ! $arg_q ) ; then
                echo "+ apm upgrade $name $verbose $quiet"
            fi
            eval $logprefix apm upgrade $name $verbose $quiet $logsuffix
            eval $logcatsed
            if ( ! $arg_q ) ; then
                echo ;
            fi
        done ;;
    *)
        flag=`apm list --bare --no-color | sed "s/@.*//" | awk "/^$arg_pkg$/"`
        if [[ -nz $flag ]] ; then
            if ( ! $arg_q ) ; then
                echo -e "+ apm upgrade $arg_pkg $verbose $quiet"
            fi
            eval $logprefix apm upgrade $arg_pkg $verbose $quiet $logsuffix
            eval $logcatsed
            if ( ! $arg_q ) ; then
                echo ;
            fi
        else
            echo -e "${blush}No package names $arg_pkg installed.${reset}"

            # did you mean
            dym=`apm list --bare --no-color | sed "s/@.*//" | grep $arg_pkg | xargs | sed "s/ /, /g"`
            if [[ -nz $dym ]] ; then
                echo "Did you mean any of the following packages: $dym?"
            fi
        fi ;;
esac
