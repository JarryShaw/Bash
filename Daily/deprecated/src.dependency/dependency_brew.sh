#!/bin/bash

printf "\n-*- Homebrew Dependency -*-\n"

# brew list | while read cask; do echo -n $fg $cask $fg; brew deps $cask | awk '{printf(" %s ", $0)}'; echo ""; done

FLG=$1

if [ $FLG == "all" ]; then
    LST=$( brew list )
    for pkg in $LST;
    do
        brew deps --tree $pkg
    done
else
    brew deps --tree $FLG
fi
