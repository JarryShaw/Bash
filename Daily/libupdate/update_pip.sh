#!/bin/bash


# preset terminal output colours
color=`tput setaf 14`   # blue
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


# pip update function usage:
#   pipupdate package 2/3 cpython/pypy system/cellar [--quiet] [--verbose]
function pipupdate {
    # parameter assignment
    local arg_pkg=$1
    local arg_V=$2
    local arg_c=$3
    local arg_s=$4
    local arg_q=$5
    local arg_v=$6

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

    # Verbose or Quiet
    if [[ -z $arg_q ]]; then
        quiet="set -x"
        regex=""
    else
        quiet=":"
        regex=" | grep -v \"\""
    fi

    # All or Specified Packages
    case $arg_pkg in
        "all")
            # list=`pipdeptree$prtf | grep -e "==" | grep -v "required"`
            list=`$pref/pip$suff list --format legacy --not-required --outdate | sed "s/\(.*\)* (.*).*/\1/"`
            if [[ -nz $list ]] ; then
                for name in $list ; do
                    if [[ -z $arg_q ]]; then
                        echo "+ pip$prtf install --upgrade --no-cache-dir $name $arg_v $arg_q"
                        $pref/pip$suff install --upgrade --no-cache-dir $name $arg_v $arg_q $regex
                        echo ;
                    else
                        $pref/pip$suff install --upgrade --no-cache-dir $name $arg_v $arg_q $regex
                    fi
                done
            else
                if [[ -z $arg_q ]]; then
                    echo "${green}All pip$prtf packages have been up-to-date.${reset}"
                    echo ;
                fi
            fi ;;
        *)
            flag=`$pref/pip$suff list --format legacy | grep -w $arg_pkg`
            if [[ -nz $flag ]] && [[ -z $arg_q ]] ; then
                echo "+ pip$prtf install --upgrade --no-cache-dir $name $arg_v $arg_q"
                $pref/pip$suff install --upgrade --no-cache-dir $name $arg_v $arg_q $regex
                echo ;
            fi ;;
    esac
}


# if quiet flag not set
# if [[ -z $arg_q ]] ; then
#     echo "-*- ${color}Python${reset} -*-"
#     echo ;
# fi


# if system flag set
if ( $arg_s ) ; then
    case $arg_V in
        1)  pipupdate $arg_pkg true true true $arg_q $arg_v
            pipupdate $arg_pkg false true true $arg_q $arg_v ;;
        2)  pipupdate $arg_pkg true true true $arg_q $arg_v ;;
        3)  pipupdate $arg_pkg false true true $arg_q $arg_v ;;
    esac
fi


# if cellar flag set
if ( $arg_b ) ; then
    # if cpython flag set
    if ( $arg_c ) ; then
        case $arg_V in
            1)  pipupdate $arg_pkg true true false $arg_q $arg_v
                pipupdate $arg_pkg false true false $arg_q $arg_v ;;
            2)  pipupdate $arg_pkg true true false $arg_q $arg_v ;;
            3)  pipupdate $arg_pkg false true false $arg_q $arg_v ;;
        esac
    fi

    # if pypy flag set
    if ( $arg_y ) ; then
        case $arg_V in
            1)  pipupdate $arg_pkg true false false $arg_q $arg_v
                pipupdate $arg_pkg false false false $arg_q $arg_v ;;
            2)  pipupdate $arg_pkg true false false $arg_q $arg_v ;;
            3)  pipupdate $arg_pkg false false false $arg_q $arg_v ;;
        esac
    fi
fi
