#!/bin/bash


################################################################################
# Log Homebrew packages uninstallation.
#
# Parameter list:
#   1. Package
################################################################################


case $1 in
    "all")
        brew list ;;
    *)
        brew deps $1 ;;
esac
