#!/bin/bash

################################################################################
# Uninstall Homebrew packages.
################################################################################

if ( $1 ) ; then
    tmp="Homebrew"
fi

printf "\n-*- Uninstalling $tmp & Dependencies -*-\n"

case $1 in
    "all")
        list=$( brew list ) ;;
    "none")
        echo "No uninstallation is done." ; exit 0 ;;
    *)
        list="$1 $( brew deps $1 )" ;;
esac

for pkg in $list ; do
    printf "\nbrew uninstall $pkg\n"
    brew uninstall --ignore-dependencies $pkg
done
