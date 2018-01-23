#!/bin/bash


# preset terminal output colours
blush=`tput setaf 1`    # blush / red
green=`tput setaf 2`    # green
reset=`tput sgr0`       # reset


################################################################################
# Check Caskroom updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Verbose Flag
#   4. Log Date
#   5. Outdated Flag
################################################################################


# parameter assignment
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


# following function of Caskroom upgrade cblushits to
#     @Atais from <apple.stackexchange.com>
#
# caskroom update function usage:
#   caskupdate cask
function caskupdate {
    # parameter assignment
    local cask=$1

    # log function call
    echo "++ caskupdate $@" >> log/update/$logdate.log

    # check for versions
    version=$(brew cask info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    if [[ -z $installed ]] ; then
        echo -e "${blush}${cask}${reset} requires ${blush}update${reset}."
        if ( ! $arg_q ) ; then
            echo "+ brew cask uninstall --force $cask $verbose $quiet"
        fi
        eval $logprefix brew cask uninstall --force $cask $verbose $quiet $logsuffix
        eval $logcatsed
        if ( ! $arg_q ) ; then
            echo -e "+ brew cask install --force $cask $verbose $quiet"
        fi
        eval $logprefix brew cask install --force $cask $verbose $quiet $logsuffix
        eval $logcatsed
        if ( ! $arg_q ) ; then
            echo ;
        fi
    else
        if ( ! $arg_q ) ; then
            echo -e "${blush}${cask}${reset} is ${green}up-to-date${reset}.\n"
        fi
    fi
}


# if quiet flag set
if ( $arg_q ) ; then
    quiet="--quiet"

    # if no outdated casks found
    if ( ! $arg_o ) ; then
        exit 0
    fi
else
    quiet=""

    # if no outdated casks found
    if ( ! $arg_o ) ; then
        echo "${green}All casks have been up-to-date.${reset}"
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
        casks=( $(brew cask list -1) )
        for cask in ${casks[@]} ; do
            caskupdate $cask
        done ;;
    *)
        flag=`brew cask list -1 | awk "/^$arg_pkg$/"`
        if [[ -nz $flag ]] ; then
            caskupdate $arg_pkg
        else
            echo -e "${blush}No cask names $arg_pkg installed.${reset}"

            # did you mean
            dym=`brew cask list -1 | grep $arg_pkg | xargs | sed "s/ /, /g"`
            if [[ -nz $dym ]] ; then
                echo "Did you mean any of the following casks: $dym?"
            fi
        fi ;;
esac
