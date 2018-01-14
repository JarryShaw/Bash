#!/bin/bash

printf "\n-*- PIP Dependency -*-\n"

FLG=$1

if [ $FLG == "all" ]; then
    pipdeptree
else
    pipdeptree -p $FLG
fi
