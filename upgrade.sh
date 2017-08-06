#!/bin/bash

echo "-*- Software -*-"

sudo softwareupdate -i -a

echo
clear

echo "-*- CPython 2.7 -*-"

LST=$(pip list --format=legacy)
CTR=1
for pkg in $LST;
do
    if [[ $[$CTR%2] == 1 ]];
    then
        printf "\npip install --upgrade $pkg\n"
        pip install --upgrade $pkg
    fi
    ((CTR++))
done

echo
clear

echo "-*- CPython 3.6 -*-"

LST=$(pip3 list --format=legacy)
CTR=1
for pkg in $LST;
do
    if [[ $[$CTR%2] == 1 ]];
    then
        printf "\npip3 install --upgrade $pkg\n"
        pip3 install --upgrade $pkg
    fi
    ((CTR++))
done

echo
clear

echo "-*- Pypy 2.7 -*-"

LST=$(pip_pypy list --format=legacy)
CTR=1
for pkg in $LST;
do
    if [[ $[$CTR%2] == 1 ]];
    then
        printf "\npip_pypy install --upgrade $pkg\n"
        pip_pypy install --upgrade $pkg
    fi
    ((CTR++))
done

echo
clear

echo "-*- Pypy 3.5 -*-"

LST=$(pip_pypy3 list --format=legacy)
CTR=1
for pkg in $LST;
do
    if [[ $[$CTR%2] == 1 ]];
    then
        printf "\npip_pypy3 install --upgrade $pkg\n"
        pip_pypy3 install --upgrade $pkg
    fi
    ((CTR++))
done

echo
clear

echo "-*- Homebrew -*-"

LST=$(brew list)
for pkg in $LST;
do
    printf "\nbrew upgrade $pkg\n"
    brew upgrade $pkg
done

echo
clear

echo "-*- Caskroom -*-"

LST=$(brew cask list)
for pkg in $LST;
do
    printf "\nbrew cask upgrade $pkg\n"
    brew cask upgrade $pkg
done

echo
clear

echo "-*- Cleanup -*-"

printf "\nbrew cleanup\n"
brew cleanup

printf "\nbrew cask cleanup\n"
brew cask cleanup
