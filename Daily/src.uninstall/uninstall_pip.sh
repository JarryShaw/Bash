#!/bin/bash

################################################################################
# Uninstall CPython 2.7 site packages.
################################################################################


name=$1
printf "\n-*- Uninstalling $name & Dependencies -*-\n"

if [ $name == "all" ]
    LST=$(pip list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip uninstall $pkg\n"
            pip uninstall $pkg
        fi
        ((CTR++))
    done
elif [ $name == "none" ]; then
    printf ""
else
    LST=$( pipdeptree -p $name )
    FLG=0
    for pkg in $LST;
    do
        if [ $FLG == 1 ]; then
            printf "\npip uninstall $pkg\n"
            pip uninstall $pkg
            FLG=0
        fi
        if [ $pkg == "-" ]; then
            FLG=1
        fi
    done
fi
