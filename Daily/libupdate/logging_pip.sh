#!/bin/bash


################################################################################
# Log Python site packages updates.
#
# Parameter list:
#   1. System Flag
#   2. Cellar Flag
#   3. CPython Flag
#   4. Pypy Flag
#   5. Version
#       |-> 1 : Both
#       |-> 2 : Python 2.*
#       |-> 3 : Python 3.*
#   6. Log Date
################################################################################


# parameter assignment
arg_s=$1
arg_b=$2
arg_c=$3
arg_y=$4
arg_V=$5
logdate=$6


# log file prepare
# logdate=`date "+%y%m%d"`
echo "+ /bin/bash $0 $@" >> log/update/$logdate.log
log="2>> log/update/$logdate.log"


# pip logging function usage:
#   piplogging 2/3 cpython/pypy system/cellar
function piplogging {
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

    eval $pref/pip$suff list --format legacy --not-required --outdate $log | sed "s/\(.*\)* (.*).*/\1/"
}


# if system flag set
if ( $arg_s ) ; then
    case $arg_V in
        1)  piplogging true true true
            piplogging false true true ;;
        2)  piplogging true true true ;;
        3)  piplogging false true true ;;
    esac
fi


# if cellar flag set
if ( $arg_b ) ; then
    # if cpython flag set
    if ( $arg_c ) ; then
        case $arg_V in
            1)  piplogging true true false
                piplogging false true false ;;
            2)  piplogging true true false ;;
            3)  piplogging false true false ;;
        esac
    fi

    # if pypy flag set
    if ( $arg_y ) ; then
        case $arg_V in
            1)  piplogging true false false
                piplogging false false false ;;
            2)  piplogging true false false ;;
            3)  piplogging false false false ;;
        esac
    fi
fi
