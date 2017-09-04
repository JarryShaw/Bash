#!/bin/bash

printf "-*- ident-user-enum -*-\n"

printf "ident-user-enum 192.168.0.106 0-65535"
for (( i=0; i<=65535; i++))
do
    ident-user-enum 192.168.0.106 $i
done
