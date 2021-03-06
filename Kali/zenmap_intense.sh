#!/usr/bin/env bash

echo -e "\n-*- Zenmap intense scan all ports -*-\n"

for (( i=1; i<=100; i++))
do
    echo -e "ZenMap intense scanning $i times.\n"
    nmap -p 1-65535 -T4 -A -v 192.168.0.*
done
