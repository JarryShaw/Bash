#!/bin/bash

################################################################################
# Clean up caches.
################################################################################

cleanup () {
    flag_brew=$1
    flag_cask=$2

    clear
    printf "\n-*- Cleanup -*-\n"

    cp -rf $(brew --cache) /PATH/TO/STORAGE
    
    if [ "$flag_brew" = true ]; then
        printf "\nbrew cleanup\n"
        rm -rf $(brew --cache)
    fi

    if [ "$flag_cask" = true ]; then
        printf "\nbrew cask cleanup\n"
        brew cask cleanup
    fi
}

################################################################################
# Upgrade certain packages or applications.
#
# $ bash upgrade.sh                         # upgrade all
# $ bash upgrade.sh -a                      # upgrade all
# $ bash upgrade.sh -m mode                 # upgrade all of `mode`
# $ bash upgrade.sh -m mode -a              # upgrade all of `mode`
# $ bash upgrade.sh -m mode -p package      # upgrade `package` of `mode`
################################################################################

name="all"
mode="all"

while getopts am:p: option
do
    case "${option}" in
        a) name="all";;
        m) mode=${OPTARG};;
        p) name=${OPTARG};;
    esac
done

if [ $mode == "all" ]; then
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_software.sh $name
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip.sh $name
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip3.sh $name
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip_pypy.sh $name
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip_pypy3.sh $name
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_brew.sh $name
    bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_cask.sh $name

    brew_flag=true
    cask_flag=true
    cleanup $brew_flag $cask_flag
else
    for flag in $mode;
    do
        brew_flag=false
        cask_flag=false

        if [ $flag == "software" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_software.sh $name
        fi
        if [ $flag == "pip" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip.sh $name
        fi
        if [ $flag == "pip3" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip3.sh $name
        fi
        if [ $flag == "pip_pypy" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip_pypy.sh $name
        fi
        if [ $flag == "pip_pypy3" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_pip_pypy3.sh $name
        fi
        if [ $flag == "brew" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_brew.sh $name
            brew_flag=true
        fi
        if [ $flag == "cask" ]; then
            bash /PATH/TO/SCRIPTS/src.upgrade/upgrade_cask.sh $name
            cask_flag=true
        fi

        cleanup $brew_flag $cask_flag
    done
fi
