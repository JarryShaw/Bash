#!/bin/bash

echo -e  "\n-*- NMap -*-\n"

for (( i=1; i<=100; i++))
do
    echo -e "\nNMap $i times.\n"
    nmap -v -A 192.168.0.*
done
