#!/bin/bash

################################################################################
# Check Homebrew updates.
################################################################################

clear
printf "\n-*- Homebrew -*-\n"

case $1 in
    "all")
        brew upgrade
        list=$( brew outdated )
        for pkg in $list ; do
            printf "\nbrew upgrade $pkg\n"
            brew upgrade $pkg
        done ;;
    "none")
        echo "No updates are done." ;;
    *)
        printf "\nbrew upgrade $1\n"
        brew upgrade $1 ;;
esac
