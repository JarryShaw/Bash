#!/bin/bash


################################################################################
# Check Python site packages updates.
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
#   6. Package
#   7. Quiet Flag
################################################################################


# pip update function usage:
#   pipupdate 2/3 cpython/pypy system/cellar package [--quiet]
function pipupdate {
    # Python 2.* or Python 3.*
    if ( $1 ) ; then
        verl="2.7"
        vers=""
    else
        verl="3.6"
        vers="3"
    fi

    # CPython or Pypy
    if ( $2 ) ; then
        # [CPython] System or Cellar
        if ( $3 ) ; then
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
    if [[ -z $5 ]]; then
        quiet="set -x"
    else
        quiet=":"
    fi

    # All or Specified Packages
    case $4 in
        "all")
            if [[ -z $5 ]]; then
                echo "+ pip$prtf install --upgrade --no-cache-dir pip $5"
                $pref/pip$suff install --upgrade --no-cache-dir pip $5
                echo ;
            fi

            # list=`pipdeptree$prtf | grep -e "==" | grep -v "required"`
            list=`$pref/pip$suff list --format="legacy" --not-required --outdate | sed "s/\(.*\)* (.*).*/\1/"`
            for name in $list ; do
                if [[ -z $5 ]]; then
                    echo "+ pip$prtf install --upgrade --no-cache-dir $name $5"
                    $pref/pip$suff install --upgrade --no-cache-dir $name $5
                    echo ;
                fi
            done ;;
        *)
            flag=`$pref/pip$suff list --format="legacy" | grep -w $4`
            if [[ -nz $flag ]] && [[ -z $5 ]] ; then
                echo "+ pip$prtf install --upgrade --no-cache-dir $4 $5"
                $pref/pip$suff install --upgrade --no-cache-dir $4 $5
                echo ;
            fi ;;
    esac
}


# Preset Terminal Output Colours
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $7 ]] ; then
    echo "-*- ${color}Python${reset} -*-\n"
fi


# if system flag set
if ( $1 ) ; then
    case "$5" in
        1)  pipupdate true true true $6 $7
            pipupdate false true true $6 $7 ;;
        2)  pipupdate true true true $6 $7 ;;
        3)  pipupdate false true true $6 $7 ;;
    esac
fi


# if cellar flag set
if ( $2 ) ; then
    # if cpython flag set
    if ( $3 ) ; then
        case "$5" in
            1)  pipupdate true true false $6 $7
                pipupdate false true false $6 $7 ;;
            2)  pipupdate true true false $6 $7 ;;
            3)  pipupdate false true false $6 $7 ;;
        esac
    fi

    # if pypy flag set
    if ( $4 ) ; then
        case "$5" in
            1)  pipupdate true false false $6 $7
                pipupdate false false false $6 $7 ;;
            2)  pipupdate true false false $6 $7 ;;
            3)  pipupdate false false false $6 $7 ;;
        esac
    fi
fi
