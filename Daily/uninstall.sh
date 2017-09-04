#!/bin/bash

################################################################################
# Uninstall dependencies of certain pakages.
# 
# - For homebrew
# $ bash uninstall.sh brew -a               # uninstall all packages
# $ bash uninstall.sh brew -p package       # uninstall dependencies of `package`
# 
# - For pip
# $ bash uninstall.sh pip -a                # uninstall all packages
# $ bash uninstall.sh pip -p package        # uninstall dependencies of `package`
# 
# - For pip3
# $ bash uninstall.sh pip3 -a               # uninstall all packages
# $ bash uninstall.sh pip3 -p package       # uninstall dependencies of `package`
# 
# - For pip_pypy
# $ bash uninstall.sh pip_pypy -a           # uninstall all packages
# $ bash uninstall.sh pip_pypy -p package   # uninstall dependencies of `package`
# 
# - For pip_pypy3
# $ bash uninstall.sh pip_pypy3 -a          # uninstall all packages
# $ bash uninstall.sh pip_pypy3 -p package  # uninstall dependencies of `package`
################################################################################

mode=$1
name="none"

while getopts ap: option
do
    case "${option}" in
        a) name="all";;
        p) name=${OPTARG};;
    esac
done

if [ $mode == "brew" ]; then
    bash ./src.uninstall/uninstall_brew.sh $name
fi

if [ $mode == "pip" ]; then
    bash ./src.uninstall/uninstall_pip.sh $name
fi

if [ $mode == "pip3" ]; then
    bash ./src.uninstall/uninstall_pip3.sh $name
fi

if [ $mode == "pip_pypy" ]; then
    bash ./src.uninstall/uninstall_pip_pypy.sh $name
fi

if [ $mode == "pip_pypy3" ]; then
    bash ./src.uninstall/uninstall_pip_pypy3.sh $name
fi
