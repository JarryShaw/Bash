#!/bin/bash

for (( i=1; i<=100; i++))
do
    echo "ZenMap intense scanning $i times."
    nmap -p 1-65535 -T4 -A -v 192.168.0.100
done
