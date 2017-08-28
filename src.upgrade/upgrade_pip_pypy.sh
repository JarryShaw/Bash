#!/bin/bash

################################################################################
# Check Pypy 2.7 site packages updates.
################################################################################

name=$1

clear
printf "\n-*- Pypy 2.7 -*-\n"

if [ $name == "all" ]; then
    LST=$(pip_pypy list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip_pypy install --upgrade $pkg\n"
            pip_pypy --no-cache-dir install --upgrade $pkg
        fi
        ((CTR++))
    done
else
    printf "\npip_pypy install --upgrade $name\n"
    pip_pypy --no-cache-dir install --upgrade $name
fi
