#!/bin/bash

num=-20
while [ $num -le 280 ]; do
    tput setaf $num
    echo "Hello, buddy! This is colour No.${num} :)"
    num=$[$num+1]
done
tput sgr0
