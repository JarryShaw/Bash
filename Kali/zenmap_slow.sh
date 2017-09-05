#!/bin/bash

printf "\n-*- Zenmap slow comprehensive scan -*-\n"

for (( i=1; i<=10; i++))
do
    echo "ZenMap slow scanning $i times."
    nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" 192.168.0.*
done
