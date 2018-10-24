#!/usr/bin/env bash

echo -e "\n-*- nbtscan-unixwiz -*-\n"

for (( i=1; i<=1000; i++))
do
    echo -e "\nnbtscan-unixwiz scanning of $i times.\n"
    nbtscan -r 192.168.0.*
done
