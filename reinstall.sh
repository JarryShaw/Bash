#!/bin/bash

################################################################################
# Reinstall certain pakages.
#
# $ bash reinstall.sh               # reinstall all
# $ bash reinstall.sh -a            # reinstall all
# $ bash reinstall.sh -p package    # reinstall `package`
# $ bash reinstall.sh -s package    # reinstall all starting from `package`
################################################################################

printf "\n-*- Reinstalling -*-\n"

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

if [ $name == "all" ]
    LST=$( brew list )
    for pkg in $LST;
    do
        printf "\nbrew reinstall $pkg\n"
        brew reinstall $pkg
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
                    printf "\nbrew reinstall $pkg\n"
                    brew reinstall $pkg
                fi
            else
                printf "\nbrew reinstall $pkg\n"
                brew reinstall $pkg
            fi  
        done
    else
        printf "\nbrew reinstall $name\n"
        brew reinstall $name
    fi
fi
