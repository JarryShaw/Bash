#!/bin/bash

echo -e "\n-*- Firewalk -*-\n"

firewalk -S0-65535 -i eth0 -n -pTCP 192.168.0.* 192.168.0.*
