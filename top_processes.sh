#!/bin/bash

# 10 processes with the highest CPU consumption
top_flags="-bcs -o %CPU -u "$(whoami)" -n 1 -w 512"
top_cmd="top ${top_flags}"
$top_cmd | grep -vE "${top_cmd}" | head -20 | awk '{print $0}'

# more info of the 5 processes with the highest CPU consumption
# TODO: use this command with awk
pidstat -dlu -p "1033,1039,918,919,138" --human
