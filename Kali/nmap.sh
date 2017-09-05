#!/bin/bash

printf  "\n-*- NMap -*-\n"

for (( i=1; i<=100; i++))
do
    printf "\nNMap $i times.\n"
    nmap -v -A 192.168.0.*
done
