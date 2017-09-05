#!/bin/bash

printf "\n-*- acccheck -*-\n"

for (( i=1; i<=1000; i++ ))
do
	printf "Scanning for $i times."
	acccheck -t  192.168.0.* -v
done

