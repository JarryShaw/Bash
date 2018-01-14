#!/bin/bash

################################################################################
# Check software updates.
################################################################################

printf "\n-*- Software -*-\n"

case $1 in
    "all")
        sudo softwareupdate -i -a ;;
    "none")
        echo "No updates are done." ;;
    *)
        sudo softwareupdate -i $1 ;;
esac
