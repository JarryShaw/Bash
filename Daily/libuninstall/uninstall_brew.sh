#!/bin/bash


################################################################################
# Uninstall Homebrew packages.
#
# Parameter list:
#   1. Quiet Flag
#   2. Verbose Flag
#   3. Yes Flag
#   4. Installed Flag
#   5. Dependency Package
#   ............
################################################################################


# brew fix missing function usage
#   brew_fixmissing set/: [--quiet] packages
function brew_fixmissing {
    quiet=$1

    # reinstall missing packages
    for $name in ${*:3} ; do
        ( $quiet; brew install $name $2; )
        if [[ -z $2 ]] ; then
            echo ;
        fi
    done

    # inform if missing packages fixed
    if [[ -z $2 ]] ; then
        echo "${green}All missing packages installed.${reset}"
    fi
}


# Preset Terminal Output Colours
red=`tput setaf 1`      # red
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


# if quiet flag not set
if [[ -z $1 ]] ; then
    echo "-*- ${color}Homebrew${reset} -*-"
    echo ;
    if ( ! $3 ) ; then
        echo "${red}No package names $4 installed.${reset}"
        exit 0
    fi
    quiet="set -x"
else
    quiet=":"
fi


# uninstall all dependency packages
for name in ${*:4} ; do
    ( $quiet; brew uninstall --force --ignore-dependencies $name $1; )
    if [[ -z $1 ]] ; then
        echo ;
    fi
done


# fix missing brew dependencies
miss=`brew missing | sed "s/.*: \(.*\)*/\1/" | sort -u | xargs`
if [[ -nz $miss ]] ; then
    echo "Required packages found missing: ${red}${miss}${reset}"
    if ( $2 ) ; then
        brew_fixmissing $quiet $1 $miss
    else
        while true ; do
            read -p "Would you like to fix? (y/N)" yn
            case $yn in
                [Yy]* )
                    brew_fixmissing $quiet $1 $miss
                    break ;;
                [Nn]* )
                    : ;;
                * )
                    echo "Invalid choice." ;;
            esac
        done
    fi
fi
