#!/bin/bash

################################################################################
# Check dependencies of site packages.
################################################################################

pip_install () {
    pip -q --no-cache-dir install $1
}

pip_uninstall () {
    pip -q uninstall $1
}

################################################################################
# Uninstall CPython 3.6 site packages.
################################################################################

name=$1
printf "\n-*- Uninstalling $name & Dependencies -*-\n"

if [ $name == "all" ]
    LST=$(pip3 list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip3 uninstall $pkg\n"
            pip3 uninstall $pkg
        fi
        ((CTR++))
    done
elif [ $name == "none" ]; then
    printf ""
else
    pip_install $name

    LST=$( pipdeptree -p $name )
    FLG=0
    for pkg in $LST;
    do
        if [ $FLG == 1 ]; then
            printf "\npip3 uninstall $pkg\n"
            pip3 uninstall $pkg
            FLG=0
        fi
        if [ $pkg == "-" ]; then
            FLG=1
        fi
    done

    pip_uninstall $name
fi
