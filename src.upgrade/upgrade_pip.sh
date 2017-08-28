#!/bin/bash

################################################################################
# Check CPython 2.7 site packages updates.
################################################################################

name=$1

clear
printf "\n-*- CPython 2.7 -*-\n"

if [ $name == "all" ]; then
    LST=$(pip list --format=legacy)
    CTR=1

    for pkg in $LST;
    do
        if [[ $[$CTR%2] == 1 ]];
        then
            printf "\npip install --upgrade $pkg\n"
            pip --no-cache-dir install --upgrade $pkg
        fi
        ((CTR++))
    done

    pip --no-cache-dir -q install --upgrade flake8
else
    printf "\npip install --upgrade $name\n"
    pip --no-cache-dir install --upgrade $name
fi
