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
################################################################################


# pip logging function usage:
#   piplogging 2/3 cpython/pypy system/cellar
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

    $pref/pip$suff list --format legacy --not-required --outdate | sed "s/\(.*\)* (.*).*/\1/"
}


# if system flag set
if ( $1 ) ; then
    case "$5" in
        1)  piplogging true true true
            piplogging false true true ;;
        2)  piplogging true true true ;;
        3)  piplogging false true true ;;
    esac
fi


# if cellar flag set
if ( $2 ) ; then
    # if cpython flag set
    if ( $3 ) ; then
        case "$5" in
            1)  piplogging true true false
                piplogging false true false ;;
            2)  piplogging true true false ;;
            3)  piplogging false true false ;;
        esac
    fi

    # if pypy flag set
    if ( $4 ) ; then
        case "$5" in
            1)  piplogging true false false
                piplogging false false false ;;
            2)  piplogging true false false ;;
            3)  piplogging false false false ;;
        esac
    fi
fi
