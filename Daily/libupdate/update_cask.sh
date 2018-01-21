#!/bin/bash


# preset terminal output colours
red=`tput setaf 1`      # red
green=`tput setaf 2`    # green
color=`tput setaf 14`   # blue
reset=`tput sgr0`       # reset


################################################################################
# Check Caskroom updates.
#
# Parameter list:
#   1. Package
#   2. Quiet Flag
#   3. Verbose Flag
#   4. Outdated Flag
################################################################################


# parameter assignment
arg_pkg=$1
arg_q=$2
arg_v=$3
arg_o=$4


# following function of Caskroom upgrade credits to
#     @Atais from <apple.stackexchange.com>
#
# caskroom update function usage:
#   caskupdate cask [--quiet] [--verbose]
function caskupdate {
    # parameter assignment
    local cask=$1
    local arg_q=$2
    local arg_v=$3

    # check for versions
    version=$(brew cask info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    # Verbose or Quiet
    if [[ -z $arg_q ]]; then
        quiet="set -x"
        regex=""
    else
        quiet=":"
        regex=" | grep -v \"\""
    fi

    if [[ -z $installed ]] ; then
        echo "${red}${cask}${reset} requires ${red}update${reset}."
        ( $quiet; brew cask uninstall --force $cask $arg_v $arg_q $regex; )
        ( $quiet; brew cask install --force $cask $arg_v $arg_q $regex; )
        if [[ -z $arg_q ]] ; then
            echo ;
        fi
    else
        if [[ -z $arg_q ]] ; then
            echo "${red}${cask}${reset} is ${green}up-to-date${reset}."
            echo ;
        fi
    fi
}


# if quiet flag not set
if [[ -z $arg_q ]] ; then
    # echo "-*- ${color}Caskroom${reset} -*-"
    # echo ;

    # if no outdated packages found
    if ( ! $arg_o ) ; then
        echo "${green}All packages have been up-to-date.${reset}"
        exit 0
    fi
else
    # if no outdated packages found
    if ( ! $arg_o ) ; then
        exit 0
    fi
fi


# All or Specified Packages
case $arg_pkg in
    "all")
        casks=( $(brew cask list -1) )
        for cask in ${casks[@]} ; do
            caskupdate $cask $arg_q $arg_v
        done ;;
    *)
        flag=`brew cask list -1 | grep -w $arg_pkg`
        if [[ -nz $flag ]] ; then
            caskupdate $arg_pkg $arg_q $arg_v
        fi ;;
esac
