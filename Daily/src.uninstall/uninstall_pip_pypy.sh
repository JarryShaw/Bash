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
# Uninstall Pypy 2.7 site packages.
################################################################################

name=$1
printf "\n-*- Uninstalling $name & Dependencies -*-\n"

if [ $name == "all" ]
    LST=$(pip_pypy list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip_pypy uninstall $pkg\n"
            pip_pypy uninstall $pkg
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
            printf "\npip_pypy uninstall $pkg\n"
            pip_pypy uninstall $pkg
            FLG=0
        fi
        if [ $pkg == "-" ]; then
            FLG=1
        fi
    done

    pip_uninstall $name
fi
