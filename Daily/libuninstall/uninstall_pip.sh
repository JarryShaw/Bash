#!/bin/bash


################################################################################
# Uninstall Python site packages.
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
#   8. Installed Flag
#   9. Dependency Package
#   ............
################################################################################


# pip fix missing function usage
#   pip_fixmissing prefix symbol suffix [--quiet] packages
function pip_fixmissing {
    pref=$1     # prefix
    suff=$2     # suffix
    prtf=$3     # printing symbol

    # reinstall missing packages
    for $name in ${*:5} ; do
        if [[ -z $4 ]] ; then
            echo "pip$suff install --no-cache-dir $name $4"
            $pref/pip$suff install --no-cache-dir $name $4
            echo ;
        else
            $pref/pip$suff install --no-cache-dir $name $4
        fi
    done

    # inform if missing packages fixed
    if [[ -z $4 ]] ; then
        echo "${green}All missing packages installed.${reset}"
    fi
}


# pip uninstall function usage:
#   pipuninstall 2/3 cpython/pypy system/cellar [--quiet] [--yes] packages
function pipuninstall {
    # Python 2.* or Python 3.*
    if ( $1 ); then
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
    if [[ -z $4 ]]; then
        quiet="set -x"
    else
        quiet=":"
    fi

    # case $6 in
    #     "all")
    #         list=`$pref/pip$suff freeze | sed "s/ *\(.*\)*==.*/\1/"` ;;
    #     *)
    #         list=`pipdeptree$prtf -f -w silence -p $6 | sed "s/ *\(.*\)*==.*/\1/" | sort -u` ;;
    # esac

    # uninstall all dependency packages
    for name in ${*:6} ; do
        ( $quiet; $pref/pip$suff uninstall $name $4 $5; )
        if [[ -z $5 ]] ; then
            echo ;
        fi
    done

    # Fix Missing Packages
    miss=`$pref/pip$suff check | sed "s/.*requires \(.*\)*, .*/\1/" | sort -u | xargs`
    if [[ -nz $miss ]] ; then
        if ( $5 ) ; then
            pip_fixmissing $pref $suff $prtf $4 $miss
        else
            echo "Required packages found missing: ${red}${miss}${reset}"
            while true ; do
                read -p "Would you like to fix? (y/N)" yn
                case $yn in
                    [Yy]* )
                        pip_fixmissing $pref $suff $prtf $4 $miss
                        break ;;
                    [Nn]* )
                        : ;;
                    * )
                        echo "Invalid choice.";;
                esac
            done
        fi
    fi
}


# Preset Terminal Output Colours
red=`tput setaf 1`      # red
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $7 ]] ; then
    echo "-*- ${color}Python${reset} -*-"
    echo ;
    if ( ! $8 ) ; then
        echo "${green}No package names $9 installed.${reset}"
        exit 0
    fi
fi


# if system flag set
if ( $1 ) ; then
    case "$5" in
        1)  pipuninstall true true true $6 $7 $8
            pipuninstall false true true $6 $7 $8 ;;
        2)  pipuninstall true true true $6 $7 $8 ;;
        3)  pipuninstall false true true $6 $7 $8 ;;
    esac
fi


# if cellar flag set
if ( $2 ) ; then
    # if cpython flag set
    if ( $3 ) ; then
        case "$5" in
            1)  pipuninstall true true false $6 $7 $8
                pipuninstall false true false $6 $7 $8 ;;
            2)  pipuninstall true true false $6 $7 $8 ;;
            3)  pipuninstall false true false $6 $7 $8 ;;
        esac
    fi

    # if pypy flag set
    if ( $4 ) ; then
        case "$5" in
            1)  pipuninstall true false false $6 $7 $8
                pipuninstall false false false $6 $7 $8 ;;
            2)  pipuninstall true false false $6 $7 $8 ;;
            3)  pipuninstall false false false $6 $7 $8 ;;
        esac
    fi
fi
