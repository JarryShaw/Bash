#!/usr/bin/env bash

num=-20
while [ $num -le 120 ]; do
    printf "\033[${num}mHello, buddy! This is ANSI code No.${num} :)\033[0m\n"
    num=$[$num+1]
done
