#!/bin/bash


################################################################################
# Log Python site packages uninstallation.
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
################################################################################


# pip logging function usage:
#   piplogging 2/3 cpython/pypy system/cellar package
function piplogging {
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
    case $4 in
        "all")
            $pref/pip$suff list --format="legacy" | sed 's/\(.*\)* (.*).*/\1/' ;;
        *)
            # pipdeptree$prtf -f -w silence -p $4 | sed 's/ *\(.*\)*==.*/\1/' | sort -u ;;
            $pref/pip$suff show $4 | grep -w "Requires" | sed "s/Requires: \(.*\)*/\1/" | sed "s/,//g"
    esac
}


# if system flag set
if ( $1 ) ; then
    case "$5" in
        1)  piplogging true true true $6
            piplogging false true true $6 ;;
        2)  piplogging true true true $6 ;;
        3)  piplogging false true true $6 ;;
    esac
fi


# if cellar flag set
if ( $2 ) ; then
    # if cpython flag set
    if ( $3 ) ; then
        case "$5" in
            1)  piplogging true true false $6
                piplogging false true false $6 ;;
            2)  piplogging true true false $6 ;;
            3)  piplogging false true false $6 ;;
        esac
    fi

    # if pypy flag set
    if ( $4 ) ; then
        case "$5" in
            1)  piplogging true false false $6
                piplogging false false false $6 ;;
            2)  piplogging true false false $6 ;;
            3)  piplogging false false false $6 ;;
        esac
    fi
fi
