#!/usr/bin/env bash

blush="\033[91m"
green="\033[96m"
reset="\033[0m"

if [ -e setup.py ] ; then
    mkdir eggs sdist wheels 2> /dev/null
    echo -e "-*- ${green}Upload to PyPi-Test${reset} -*-\n"
    rm -rf build 2> /dev/null
    mv dist/*.egg eggs/ 2> /dev/null
    mv dist/*.whl wheels/ 2> /dev/null
    mv dist/*.tar.gz sdist/ 2> /dev/null
    ( set -x; python setup.py sdist bdist_wheel; twine upload dist/* -r pypitest --skip-existing )
else
    echo -e "${blush}Error${reset}: do not find setup.py in $PWD"
fi
