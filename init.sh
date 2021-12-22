#!/bin/bash

nmcli radio wifi on

[ "enabled" == "$(nmcli radio wifi)" ] && nmcli device connect wlp2s0 --ask

nmcli device show wlp2s0 | grep 'GENERAL\.STATE:' | awk '{ if("(connected)" == $3"") exit 0 }' && sudo apt update

for pkey in $(find $HOME/.ssh/ -type f \( -perm 'u=rw' ! -perm 'g=rw,o=rw' \)); do
    ssh-add $pkey
done
