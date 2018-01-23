#!/bin/bash


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
    cmd_q="-q"
else
    quiet=""
fi


# if verbose flag not set
if ( $arg_v ) ; then
    verbose="--verbose"
    cmd_v="-v"
else
    verbose=""
fi


# brew prune
if ( ! $arg_q ) ; then
    echo "+ brew prune $verbose $quiet"
fi
eval $logprefix brew prune $verbose $quiet $logsuffix
eval $logcatsed
if ( ! $arg_q ) ; then
    echo ;
fi


# archive caches if hard disk attached
if [ -e /Volumes/Jarry\ Shaw/ ] ; then
    if ( ! $arg_q ) ; then
        echo "+ cp -rf cache archive $verbose $quiet"
    fi
    eval $logprefix cp -rf $cmd_v $(brew --cache) /Volumes/Jarry\ Shaw/Developers/ $logsuffix
    eval $logcatsed
    if ( ! $arg_q ) ; then
        echo ;
    fi

    if ( $arg_cask ) ; then
        if ( ! $arg_q ) ; then
            echo "+ brew cask cleanup $verbose $quiet"
        fi
        eval $logprefix brew cask cleanup $verbose $logsuffix
        eval $logcatsed
        if ( ! $arg_q ) ; then
            echo ;
        fi
    fi

    if ( $arg_brew ) ; then
        if ( ! $arg_q ) ; then
            echo "+ brew cleanup $verbose $quiet"
        fi
        eval $logprefix rm -rf $cmd_v $( brew --cache ) $logsuffix
        eval $logcatsed
        if ( ! $arg_q ) ; then
            echo ;
        fi
    fi
fi
