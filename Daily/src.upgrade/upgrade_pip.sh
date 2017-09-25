#!/bin/bash

################################################################################
# Check Python site packages updates.
################################################################################

clear
printf "\n-*- Python -*-\n"

# pipupgrade 2/3 cpython/pypy system/cellar
function pipupgrade {
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

    case $4 in 
        "all")
            list=`pipdeptree$prtf | grep -e "=="`
            for name in $list ; do
                pkg=${name%==*}
                printf "\npip$prtf install --upgrade $pkg\n"
                $pref/pip$suff install --upgrade --no-cache-dir $pkg
            done ;;
        "none")
            echo "No updates are done." ; exit 0 ;;
        *)
            printf "\npip$prtf install --upgrade $4\n"
            $pref/pip$suff install --upgrade --no-cache-dir $4 ;;
    esac
}

if ( $1 ) ; then
    case "$5" in
        1)  pipupgrade true true true $6
            pipupgrade false true true $6 ;;
        2)  pipupgrade true true true $6 ;;
        3)  pipupgrade false true true $6 ;;
    esac
fi

if ( $2 ) ; then
    if ( $3 ) ; then
        case "$5" in
            1)  pipupgrade true true false $6
                pipupgrade false true false $6 ;;
            2)  pipupgrade true true false $6 ;;
            3)  pipupgrade false true false $6 ;;
        esac
    fi

    if ( $4 ) ; then
        case "$5" in
            1)  pipupgrade true false false $6
                pipupgrade false false false $6 ;;
            2)  pipupgrade true false false $6 ;;
            3)  pipupgrade false false false $6 ;;
        esac
    fi
fi
