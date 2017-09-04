#!/bin/bash

echo "-*- acccheck -*-"

for (( i=1; i<=1000; i++ ))
do
	echo "Scanning for ${red}${i}${reset} times."
	acccheck -t  192.168.0.106 -v
done

