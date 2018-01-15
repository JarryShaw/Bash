#!/bin/bash


################################################################################
# Log Python site packages uninstallation.
################################################################################


# function usage:
#   piplogging 2/3 cpython/pypy system/cellar package
function piplogging {
    if ( $1 ) ; then
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

    case $4 in
        "all")
            $pref/pip$suff list --format="legacy" | sed 's/\(.*\)* (.*).*/\1/' ;;
        *)
            pipdeptree$prtf -f -w silence -p $4 | sed 's/ *\(.*\)*==.*/\1/' | sort -u ;;
    esac

}

if ( $1 ) ; then
    case "$5" in
        1)  piplogging true true true $6
            piplogging false true true $6 ;;
        2)  piplogging true true true $6 ;;
        3)  piplogging false true true $6 ;;
    esac
fi

if ( $2 ) ; then
    if ( $3 ) ; then
        case "$5" in
            1)  piplogging true true false $6
                piplogging false true false $6 ;;
            2)  piplogging true true false $6 ;;
            3)  piplogging false true false $6 ;;
        esac
    fi

    if ( $4 ) ; then
        case "$5" in
            1)  piplogging true false false $6
                piplogging false false false $6 ;;
            2)  piplogging true false false $6 ;;
            3)  piplogging false false false $6 ;;
        esac
    fi
fi
