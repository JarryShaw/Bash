#!/bin/bash

printf "\n-*- ident-user-enum -*-\n"

printf "ident-user-enum 192.168.0.* 0-65535\n"
for (( i=0; i<=65535; i++))
do
    ident-user-enum 192.168.0.* $i
done
