#!/bin/bash

printf "-*- nbtscan-unixwiz -*-\n"

for (( i=1; i<=1000; i++))
do
    printf "\nnbtscan-unixwiz scanning of $i times.\n"
    nbtscan -r 192.168.0.100
done
