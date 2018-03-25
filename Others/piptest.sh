#!/bin/bash

ver=$1
pkg=$2

blush=`tput setaf 1`
reset=`tput sgr0`

case $ver in
    20)  # pip2.0
        prefix="/Library/Frameworks/Python.framework/Versions/2.0/bin"
        suffix="2.0"
        pprint="2.0" ;;
    21)  # pip2.1
        prefix="/Library/Frameworks/Python.framework/Versions/2.1/bin"
        suffix="2.1"
        pprint="2.1" ;;
    22)  # pip2.2
        prefix="/Library/Frameworks/Python.framework/Versions/2.2/bin"
        suffix="2.2"
        pprint="2.2" ;;
    23)  # pip2.3
        prefix="/Library/Frameworks/Python.framework/Versions/2.3/bin"
        suffix="2.3"
        pprint="2.3" ;;
    24)  # pip2.4
        prefix="/Library/Frameworks/Python.framework/Versions/2.4/bin"
        suffix="2.4"
        pprint="2.4" ;;
    25)  # pip2.5
        prefix="/Library/Frameworks/Python.framework/Versions/2.5/bin"
        suffix="2.5"
        pprint="2.5" ;;
    26)  # pip2.6
        prefix="/Library/Frameworks/Python.framework/Versions/2.6/bin"
        suffix="2.6"
        pprint="2.6" ;;
    27)  # pip2.7
        prefix="/Library/Frameworks/Python.framework/Versions/2.7/bin"
        suffix="2.7"
        pprint="2.7" ;;
    30)  # pip3.0
        prefix="/Library/Frameworks/Python.framework/Versions/3.0/bin"
        suffix="3.0"
        pprint="3.0" ;;
    31)  # pip3.1
        prefix="/Library/Frameworks/Python.framework/Versions/3.1/bin"
        suffix="3.1"
        pprint="3.1" ;;
    32)  # pip3.2
        prefix="/Library/Frameworks/Python.framework/Versions/3.2/bin"
        suffix="3.2"
        pprint="3.2" ;;
    33)  # pip3.3
        prefix="/Library/Frameworks/Python.framework/Versions/3.3/bin"
        suffix="3.3"
        pprint="3.3" ;;
    34)  # pip3.4
        prefix="/Library/Frameworks/Python.framework/Versions/3.4/bin"
        suffix="3.4"
        pprint="3.4" ;;
    35)  # pip3.5
        prefix="/Library/Frameworks/Python.framework/Versions/3.5/bin"
        suffix="3.5"
        pprint="3.5" ;;
    36)  # pip3.6
        prefix="/Library/Frameworks/Python.framework/Versions/3.6/bin"
        suffix="3.6"
        pprint="3.6" ;;
    37)  # pip3.7
        prefix="/Library/Frameworks/Python.framework/Versions/3.7/bin"
        suffix="3.7"
        pprint="3.7" ;;
    2|pip2)  # pip2
        prefix="/usr/local/opt/python@2/bin"
        suffix="2"
        pprint="2"
        # link brewed python@2
        brew link python@2 --force > /dev/null 2>&1 ;;
    3|pip3)  # pip3
        prefix="/usr/local/opt/python@3/bin"
        suffix="3"
        pprint="3"
        # link brewed python
        brew link python > /dev/null 2>&1 ;;
    pypy2)  # pip_pypy
        prefix="/usr/local/opt/pypy/bin"
        suffix="_pypy"
        pprint="_pypy"
        # link brewed pypy
        brew link pypy > /dev/null 2>&1 ;;
    pypy3)  # pip_pypy3
        prefix="/usr/local/opt/pypy3/bin"
        suffix="_pypy3"
        pprint="_pypy3"
        # link brewed pypy3
        brew link pypy3 > /dev/null 2>&1 ;;
esac

if [ -e $prefix/pip$suffix ] ; then
	list=`$prefix/pip$suffix install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple -I $pkg==newest 2>&1 | grep "from versions: " | sed "s/.*(from versions: \(.*\)*)/\1/"`
	IFS=', ' read -ra array <<< "$list"
	length=$[${#array[@]} - 1]
	newest=${array[$length]}
    ( set -x; sudo $prefix/pip$suffix install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple -I $pkg==$newest --upgrade --no-cache-dir )
else
    echo "${blush}Error: pip$pprint not installed${reset}"
fi
