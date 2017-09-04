#!/bin/bash

for (( i=1; i<=1000; i++))
do
    echo "ZenMap quick scanning $i times."
    nmap -sV -T4 -O -F --version-light 192.168.0.100
done
