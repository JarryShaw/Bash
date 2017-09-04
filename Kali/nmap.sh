#!/bin/bash

for (( i=1; i<=100; i++))
do
    echo "NMap $i times."
    nmap -v -A 192.168.0.100
done
