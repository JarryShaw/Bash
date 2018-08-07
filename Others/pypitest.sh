#!/bin/bash

blush="\033[91m"
green="\033[96m"
reset="\033[0m"

if [ -e setup.py ] ; then
    mkdir egg sdist wheels 2> /dev/null
    echo -e "-*- ${green}Upload to PyPi-Test${reset} -*-\n"
    rm -rf build
    mv -f dist/*.egg eggs/
    mv -f dist/*.whl wheels/
    mv -f dist/*.tar.gz sdist/
    ( set -x; python setup.py sdist bdist_wheel; twine upload dist/* upload -r pypitest --skip-existing )
else
    echo -e "${blush}Error${reset}: do not find setup.py in $PWD"
fi
