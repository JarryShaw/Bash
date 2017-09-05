#!/bin/bash

################################################################################
# Check dependencies of certain pakages.
#
# - For homebrew
# $ bash dependency.sh -m brew 				# show all dependencies
# $ bash dependency.sh -m brew -a           # show all dependencies
# $ bash dependency.sh -m brew -p package   # show dependency of `package`
# 
# - For pip
# $ bash dependency.sh -m pip               # show all dependencies
# $ bash dependency.sh -m pip -a            # show all dependencies
# $ bash dependency.sh -m pip -p package    # show dependency of `package`
################################################################################

mode="none"
name="all"

while getopts am:p: option
do
    case "${option}" in
        a) name="all";;
		m) mode=${OPTARG};;
        p) name=${OPTARG};;
    esac
done

if [ $mode == "brew" ]; then
    bash /PATH/TO/SCRIPTS/src.dependency/dependency_brew.sh $name
fi

if [ $mode == "pip" ]; then
    bash /PATH/TO/SCRIPTS/src.dependency/dependency_pip.sh $name
fi
