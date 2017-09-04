#!/bin/bash

name=$1
printf "\n-*- Uninstalling $name & Dependencies -*-\n"

if [ $name == "all" ]
    LST=$( brew list $name )
    for pkg in $LST;
    do
        printf "\nbrew uninstall $pkg\n"
        brew uninstall $pkg
    done
elif [ $name == "none" ]; then
    printf ""
else
    LST=$( brew deps $name )
    for pkg in $LST;
    do
        printf "\nbrew uninstall $pkg\n"
        brew uninstall $pkg
    done
fi
