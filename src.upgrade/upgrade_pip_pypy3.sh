#!/bin/bash

################################################################################
# Check Pypy 3.5 site packages updates.
################################################################################

name=$1

clear
printf "\n-*- Pypy 3.5 -*-\n"

if [ $name == "all" ]; then
    LST=$(pip_pypy3 list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip_pypy3 install --upgrade $pkg\n"
            pip_pypy3 --no-cache-dir install --upgrade $pkg
        fi
        ((CTR++))
    done
else
    printf "\npip_pypy3 install --upgrade $name\n"
    pip_pypy3 --no-cache-dir install --upgrade $name
fi
