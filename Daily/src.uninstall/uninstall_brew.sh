#!/bin/bash

name=$1
printf "\n-*- Uninstalling $name & Dependencies -*-\n"

if [ $name == "all" ]; then
    LST=$( brew list $name )
    for pkg in $LST;
    do
        printf "\nbrew uninstall $pkg\n"
        brew uninstall --ignore-dependencies $pkg
    done
elif [ $name == "none" ]; then
    printf "\nNothing uninstalled.\n"
else
    printf "\nbrew uninstall $name\n"
    brew uninstall $name

    LST=$( brew deps $name )
    for pkg in $LST;
    do
        printf "\nbrew uninstall $pkg\n"
        brew uninstall --ignore-dependencies $pkg
    done
fi
