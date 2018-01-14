#!/bin/bash


color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Check Python site packages updates.
################################################################################


echo "-*- ${color}Python${reset} -*-"

# function usage:
#   pipupdate 2/3 cpython/pypy system/cellar package --quiet
function pipupdate {
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
            ( set -x; $pref/pip$suff install --upgrade --no-cache-dir $5 pip; )

            # list=`pipdeptree$prtf | grep -e "==" | grep -v "required"`
            list=`$pref/pip$suff list --format="legacy" --not-required --outdate`
            for name in $list ; do
                pkg=${name% \(*}
                ( set -x; $pref/pip$suff install --upgrade --no-cache-dir $5 $pkg; )
            done ;;
        *)
            flag=`$pref/pip$suff list --format="legacy" | grep -w $4`
            if [[ $flag ]] ; then
                ( set -x; $pref/pip$suff install --upgrade --no-cache-dir $5 $4; )
            fi ;;
    esac
}

if ( $1 ) ; then
    case "$5" in
        1)  pipupdate true true true $6 $7
            pipupdate false true true $6 $7 ;;
        2)  pipupdate true true true $6 $7 ;;
        3)  pipupdate false true true $6 $7 ;;
    esac
fi

if ( $2 ) ; then
    if ( $3 ) ; then
        case "$5" in
            1)  pipupdate true true false $6 $7
                pipupdate false true false $6 $7 ;;
            2)  pipupdate true true false $6 $7 ;;
            3)  pipupdate false true false $6 $7 ;;
        esac
    fi

    if ( $4 ) ; then
        case "$5" in
            1)  pipupdate true false false $6 $7
                pipupdate false false false $6 $7 ;;
            2)  pipupdate true false false $6 $7 ;;
            3)  pipupdate false false false $6 $7 ;;
        esac
    fi
fi
