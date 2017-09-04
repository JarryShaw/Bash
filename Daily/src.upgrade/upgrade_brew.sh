#!/bin/bash

################################################################################
# Check Homebrew updates.
################################################################################

name=$1

clear
printf "\n-*- Homebrew -*-\n"

if [ $name == "all" ]; then
    LST=$(brew list)
    for pkg in $LST;
    do
        printf "\nbrew upgrade $pkg\n"
        brew upgrade $pkg
    done
else
    printf "\nbrew upgrade $name\n"
    brew upgrade $name
fi
