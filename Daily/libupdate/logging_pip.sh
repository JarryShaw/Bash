#!/bin/bash


################################################################################
# Log Python site packages updates.
################################################################################


# function usage:
#   piplogging 2/3 cpython/pypy system/cellar
function piplogging {
    if ( $1 ); then
        verl="2.7"
        vers=""
    else
        verl="3.6"
        vers="3"
    fi

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

    list=`$pref/pip$suff list --format="legacy" --not-required --outdate`
    for name in $list ; do
        echo ${name% \(*}
    done
}

if ( $1 ) ; then
    case "$5" in
        1)  piplogging true true true
            piplogging false true true ;;
        2)  piplogging true true true ;;
        3)  piplogging false true true ;;
    esac
fi

if ( $2 ) ; then
    if ( $3 ) ; then
        case "$5" in
            1)  piplogging true true false
                piplogging false true false ;;
            2)  piplogging true true false ;;
            3)  piplogging false true false ;;
        esac
    fi

    if ( $4 ) ; then
        case "$5" in
            1)  piplogging true false false
                piplogging false false false ;;
            2)  piplogging true false false ;;
            3)  piplogging false false false ;;
        esac
    fi
fi
