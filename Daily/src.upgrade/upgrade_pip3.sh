#!/bin/bash

################################################################################
# Check CPython 3.6 site packages updates.
################################################################################

name=$1

clear
printf "\n-*- CPython 3.6 -*-\n"

if [ $name == "all" ]; then
    LST=$(pip3 list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip3 install --upgrade $pkg\n"
            pip3 --no-cache-dir install --upgrade $pkg
        fi
        ((CTR++))
    done
else
    printf "\npip3 install --upgrade $name\n"
    pip3 --no-cache-dir install --upgrade $name
fi
