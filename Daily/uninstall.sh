#!/bin/bash

################################################################################
# Uninstall dependencies of certain pakages.
#
# - For homebrew
# $ bash uninstall.sh -m brew -a 				# uninstall all packages
# $ bash uninstall.sh -m brew -p package    	# uninstall dependencies of `package`
# 
# - For pip
# $ bash uninstall.sh -m pip -a             	# uninstall all packages
# $ bash uninstall.sh -m pip -p package     	# uninstall dependencies of `package`
# 
# - For pip3
# $ bash uninstall.sh -m pip3 -a            	# uninstall all packages
# $ bash uninstall.sh -m pip3 -p package    	# uninstall dependencies of `package`
# 
# - For pip_pypy
# $ bash uninstall.sh -m pip_pypy -a        	# uninstall all packages
# $ bash uninstall.sh -m pip_pypy -p package	# uninstall dependencies of `package`
# 
# - For pip_pypy3
# $ bash uninstall.sh -m pip_pypy3 -a          	# uninstall all packages
# $ bash uninstall.sh -m pip_pypy3 -p package  	# uninstall dependencies of `package`
################################################################################

mode="none"
name="none"

while getopts am:p: option
do
    case "${option}" in
        a) name="all";;
		m) mode=${OPTARG};;
        p) name=${OPTARG};;
    esac
done

if [ $mode == "none" ]; then
	printf "\nNothing will be uninstalled.\n"
elif [ $mode == "brew" ]; then
    bash /PATH/TO/SCRIPTS/src.uninstall/uninstall_brew.sh $name
elif [ $mode == "pip" ]; then
    bash /PATH/TO/SCRIPTS/src.uninstall/uninstall_pip.sh $name
elif [ $mode == "pip3" ]; then
    bash /PATH/TO/SCRIPTS/src.uninstall/uninstall_pip3.sh $name
elif [ $mode == "pip_pypy" ]; then
    bash /PATH/TO/SCRIPTS/src.uninstall/uninstall_pip_pypy.sh $name
elif [ $mode == "pip_pypy3" ]; then
    bash /PATH/TO/SCRIPTS/src.uninstall/uninstall_pip_pypy3.sh $name
fi
