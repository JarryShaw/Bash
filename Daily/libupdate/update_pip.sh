#!/bin/bash


# preset terminal output colours
blush=`tput setaf 1`    # blush / red
green=`tput setaf 2`    # green
reset=`tput sgr0`       # reset


################################################################################
# Check Python site packages updates.
#
# Parameter list:
#   1. Package
#   2. System Flag
#   3. Cellar Flag
#   4. CPython Flag
#   5. Pypy Flag
#   6. Version
#       |-> 1 : Both
#       |-> 2 : Python 2.*
#       |-> 3 : Python 3.*
#   7. Quiet Flag
#   8. Verbose Flag
#   9. Log Date
################################################################################


# parameter assignment
arg_pkg=$1
arg_s=$2
arg_b=$3
arg_c=$4
arg_y=$5
arg_V=$6
arg_q=$7
arg_v=$8
logdate=$9


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


# pip update function usage:
#   pipupdate 2/3 cpython/pypy system/cellar
function pipupdate {
    # parameter assignment
    local arg_V=$1
    local arg_c=$2
    local arg_s=$3

    # log function call
    echo "++ pipupdate $@" >> log/update/$logdate.log

    # Python 2.* or Python 3.*
    if ( $arg_V ) ; then
        verl="2.7"
        vers=""
    else
        verl="3.6"
        vers="3"
    fi

    # CPython or Pypy
    if ( $arg_c ) ; then
        # [CPython] System or Cellar
        if ( $arg_s ) ; then
            pref="/Library/Frameworks/Python.framework/Versions/$verl/bin"
            prtf="_sys$vers"
        else
            pref="/usr/local/opt/python$vers/bin"
            prtf="$vers"
        fi
        suff="$vers"
    else
        pref="/usr/local/opt/pypy$vers/bin"
        suff="_pypy$vers"
        prtf="_pypy$vers"
    fi

    # All or Specified Packages
    case $arg_pkg in
        "all")
            # list=`pipdeptree$prtf | grep -e "==" | grep -v "required"`
            list=`$pref/pip$suff list --format legacy --not-required --outdate | sed "s/\(.*\)* (.*).*/\1/"`
            if [[ -nz $list ]] ; then
                for name in $list ; do
                    if ( ! $arg_q ); then
                        echo "+ pip$prtf install --upgrade --no-cache-dir $name $verbose $quiet"
                    fi
                    eval $logprefix $pref/pip$suff install --upgrade --no-cache-dir $name $verbose $quiet $logsuffix
                    eval $logcatsed
                    if ( ! $arg_q ); then
                        echo ;
                    fi
                done
            else
                if ( ! $arg_q ); then
                    echo "${green}All pip$prtf packages have been up-to-date.${reset}"
                    echo ;
                fi
            fi ;;
        *)
            flag=`$pref/pip$suff list --format legacy | awk "/^$arg_pkg$/"`
            if [[ -nz $flag ]]; then
                if ( ! $arg_q ) ; then
                    echo -e "+ pip$prtf install --upgrade --no-cache-dir $arg_pkg $verbose $quiet"
                fi
                eval $logprefix $pref/pip$suff install --upgrade --no-cache-dir $arg_pkg $verbose $quiet $logsuffix
                eval $logcatsed
                if ( ! $arg_q ) ; then
                    echo ;
                fi
            else
                echo -e "${blush}No pip$prtf package names $arg_pkg installed.${reset}"

                # did you mean
                dym=`pip list --format legacy | grep $arg_pkg | xargs | sed "s/ /, /g"`
                if [[ -nz $dym ]] ; then
                    echo "Did you mean any of the following packages: $dym?"
                fi
            fi ;;
    esac
}


# if quiet flag set
if ( $arg_q ) ; then
    quiet="--quiet"
else
    quiet=""
fi


# if verbose flag set
if ( $arg_v ) ; then
    verbose="--verbose"
else
    verbose=""
fi


# if system flag set
if ( $arg_s ) ; then
    case $arg_V in
        1)  pipupdate true true true
            pipupdate false true true ;;
        2)  pipupdate true true true ;;
        3)  pipupdate false true true ;;
    esac
fi


# if cellar flag set
if ( $arg_b ) ; then
    # if cpython flag set
    if ( $arg_c ) ; then
        case $arg_V in
            1)  pipupdate true true false
                pipupdate false true false ;;
            2)  pipupdate true true false ;;
            3)  pipupdate false true false ;;
        esac
    fi

    # if pypy flag set
    if ( $arg_y ) ; then
        case $arg_V in
            1)  pipupdate true false false
                pipupdate false false false ;;
            2)  pipupdate true false false ;;
            3)  pipupdate false false false ;;
        esac
    fi
fi
