#!/bin/bash

echo -e "\n-*- ident-user-enum -*-\n"

echo "ident-user-enum 192.168.0.* 0-65535"
for (( i=0; i<=65535; i++))
do
    ident-user-enum 192.168.0.* $i
done
