#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
color=`tput setaf 14`
reset=`tput sgr0`


################################################################################
# Uninstall Python site packages.
################################################################################


echo "-*- ${color}Python${reset} -*-"

# function usage
#   pip_fixmissing --quiet missing pref suff
function pip_fixmissing {
    pref=$3
    suff=$4
    for $name in $2 ; do
        if [[ -z $1 ]] ; then
            ( set -x; $pref/pip$suff install --no-cache-dir $name; ); echo
        else
            $pref/pip$suff install --no-cache-dir $1 $name
        fi
    done
    echo "${green}Missing packages installed.${reset}"
}

# function usage:
#   pipuninstall 2/3 cpython/pypy system/cellar package --quiet --yes
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
            list=`$pref/pip$suff freeze | sed 's/ *\(.*\)*==.*/\1/'` ;;
        *)
            list=`pipdeptree$prtf -f -w silence -p $4 | sed 's/ *\(.*\)*==.*/\1/' | sort -u` ;;
    esac

    for name in $list ; do
        ( set -x; $pref/pip$suff uninstall -y $5 $pkg; ); echo
    done

    miss=`$pref/pip$suff check | sed 's/.*requires \(.*\)*, .*/\1/' | sort -u | xargs`
    if [[ -nz $miss ]] ; then
        if ( $6 ) ; then
            pip_fixmissing $5 $miss $pref $suff
        else
            echo "Required packages found missing: ${red}${miss}${reset}"
            while true ; do
                read -p "Would you like to fix? (y/N)" yn
                case $yn in
                    [Yy]* )
                        pip_fixmissing $5 $miss $pref $suff
                        break ;;
                    [Nn]* ) : ;;
                    * ) echo "Invalid choice.";;
                esac
            done
        fi
    fi
}

if ( $1 ) ; then
    case "$5" in
        1)  pipuninstall true true true $6 $7 $8
            pipuninstall false true true $6 $7 $8 ;;
        2)  pipuninstall true true true $6 $7 $8 ;;
        3)  pipuninstall false true true $6 $7 $8 ;;
    esac
fi

if ( $2 ) ; then
    if ( $3 ) ; then
        case "$5" in
            1)  pipuninstall true true false $6 $7 $8
                pipuninstall false true false $6 $7 $8 ;;
            2)  pipuninstall true true false $6 $7 $8 ;;
            3)  pipuninstall false true false $6 $7 $8 ;;
        esac
    fi

    if ( $4 ) ; then
        case "$5" in
            1)  pipuninstall true false false $6 $7 $8
                pipuninstall false false false $6 $7 $8 ;;
            2)  pipuninstall true false false $6 $7 $8 ;;
            3)  pipuninstall false false false $6 $7 $8 ;;
        esac
    fi
fi
