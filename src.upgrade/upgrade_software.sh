#!/bin/bash

################################################################################
# Check software updates.
################################################################################

name=$1

printf "\n-*- Software -*-\n"

if [ $name == "all" ]; then
    sudo softwareupdate -i -a
else
    sudo softwareupdate -i $name
fi
