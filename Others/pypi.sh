#!/bin/bash

blush="\033[91m"
green="\033[96m"
reset="\033[0m"

if [ -e setup.py ] ; then
    echo -e "-*- ${green}Upload to PyPi-Test${reset} -*-\n"
    ( set -x; python setup.py sdist bdist_wheel upload -r pypitest )
    # ( set -x; twine upload dist/* -r pypitest --skip-existing )
    tput clear
    echo -e "-*- ${green}Upload to PyPi-Test${reset} -*-\n"
    ( set -x; python setup.py sdist bdist_wheel upload -r pypi )
    # ( set -x; twine upload dist/* -r pypi --skip-existing )
else
    echo -e "${blush}Error${reset}: do not find setup.py in $PWD"
fi
