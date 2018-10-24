#!/usr/bin/env bash

# install requirements
sudo apt-get update
sudo apt-get install -y \
    python3 \
    python3-pip
sudo --set-home python3 -m pip install --upgrade \
    pip \
    wheel \
    setuptools \
    ipython \
    pipenv

# prepare Pipenv
cd ~/Desktop
pipenv install ipython --dev
