#!/bin/bash

################################################################################
# Uninstall Python site packages.
################################################################################

if ( $1 ) ; then
    tmp="all"
fi

printf "\n-*- Uninstalling $tmp & Dependencies -*-\n"

# pipuninstall 2/3 cpython/pypy system/cellar
function pipuninstall {
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
            list=`$pref/pip$suff freeze | grep -e "=="` ;;
        "none")
            echo "No uninstallation is done." ; exit 0 ;;
        *)
            list=`pipdeptree$prtf -f -p $4 | grep -e "=="` ;;
    esac

    for name in $list ; do
        pkg=${name%==*}
        case "$pkg" in
            "pip"|"setuptools"|"wheel"|"pipdeptree")
                : ;;
            *)  
                printf "\npip$prtf uninstall $pkg\n"
                $pref/pip$suff uninstall -q $pkg ;;
        esac
    done 
}

if ( $1 ) ; then
    case "$5" in
        1)  pipuninstall true true true $6
            pipuninstall false true true $6 ;;
        2)  pipuninstall true true true $6 ;;
        3)  pipuninstall false true true $6 ;;
    esac
fi

if ( $2 ) ; then
    if ( $3 ) ; then
        case "$5" in
            1)  pipuninstall true true false $6
                pipuninstall false true false $6 ;;
            2)  pipuninstall true true false $6 ;;
            3)  pipuninstall false true false $6 ;;
        esac
    fi

    if ( $4 ) ; then
        case "$5" in
            1)  pipuninstall true false false $6
                pipuninstall false false false $6 ;;
            2)  pipuninstall true false false $6 ;;
            3)  pipuninstall false false false $6 ;;
        esac
    fi
fi
