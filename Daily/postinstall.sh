#!/bin/bash

################################################################################
# Postinstall certain pakages.
#
# $ bash postinstall.sh             # postinstall all
# $ bash postinstall.sh -a          # postinstall all
# $ bash postinstall.sh -p package  # postinstall `package`
# $ bash postinstall.sh -s package  # postinstall all starting from `package`
################################################################################

printf "\n-*- Postinstalling -*-\n"

name="all"
flag=false

while getopts ap:s: option
do
    case "${option}" in
        a)
            name="all"
            ;;
        p)
            name=${OPTARG}
            ;;
        s)
            name=${OPTARG}
            flag=true
            ;;
    esac
done

if [ $name == "all" ]; then
    LST=$( brew list )
    for pkg in $LST;
    do
        printf "\nbrew postinstall $pkg\n"
        brew postinstall $pkg
    done
else
    if [ "$flag" == true ]; then
        LST=$(brew list)
        FLG=0
        for pkg in $LST;
        do
            if [[ $FLG == 0 ]]; then
                if [[ $pkg == $name ]]; then
                    FLG=1
                    printf "\nbrew postinstall $pkg\n"
                    brew postinstall $pkg
                fi
            else
                printf "\nbrew postinstall $pkg\n"
                brew postinstall $pkg
            fi  
        done
    else
        printf "\nbrew postinstall $name\n"
        brew postinstall $name
    fi
fi
