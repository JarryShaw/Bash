#!/bin/bash

################################################################################
# Check dependencies of certain pakages.
#
# - For homebrew
# $ bash dependency.sh brew                 # show all dependencies
# $ bash dependency.sh brew -a              # show all dependencies
# $ bash dependency.sh brew -p package      # show dependency of `package`
# 
# - For pip
# $ bash dependency.sh pip                  # show all dependencies
# $ bash dependency.sh pip -a               # show all dependencies
# $ bash dependency.sh pip -p package       # show dependency of `package`
################################################################################

mode=$1
name="all"

while getopts ap: option
do
    case "${option}" in
        a) name="all";;
        p) name=${OPTARG};;
    esac
done

if [ $mode == "brew" ]; then
    bash ./src.dependency/dependency_brew.sh $name
fi

if [ $mode == "pip" ]; then
    bash ./src.dependency/dependency_pip.sh $name
fi
