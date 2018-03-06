#!/bin/bash

blush=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ -e setup.py ] ; then
    echo "-*- ${green}Register in PyPi-Test${reset} -*-"
    python setup.py register -r pypitest
    sleep 3
    tput clear
    echo "-*- ${green}Upload to PyPi-Test${reset} -*-"
    python setup.py sdist upload -r pypitest
    sleep 3
    tput clear
    echo "-*- ${green}Register in PyPi${reset} -*-"
    python setup.py register -r pypi
    sleep 3
    tput clear
    echo "-*- ${green}Upload to PyPi${reset} -*-"
    python setup.py sdist upload -r pypi
else
    echo "${blush}Error: do not find setup.py in $PWD${reset}"
fi
