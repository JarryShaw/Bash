#!/usr/bin/env bash

# print a trace of simple commands
set -x

# install requirements
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    net-tools \
    python3 \
    python3-pip
sudo --set-home python3 -m pip install --upgrade \
    pip \
    wheel \
    setuptools \
    ipython \
    pipenv

# # create user "linuxbrew"
# adduser linuxbrew
# usermod -aG sudo linuxbrew
# su - linuxbrew
# returncode=$?
# if [[ $returncode -ne 0 ]] ; then
#     exit $returncode
# fi
# logout

# # install Linuxbrew
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
# test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
# test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
# test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
# echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile
# logout linuxbrew

# prepare Pipenv
cd ~/Desktop
pipenv install ipython --dev
