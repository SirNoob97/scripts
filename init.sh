#!/bin/env bash

set -u -o pipefail

interface='wlp2s0'
repository_managers='apt yum apt-get dnf"'
repository_manager=''
update_command=''

for manager in $repository_managers; do
  command -v $manager > /dev/null 2>&1 && repository_manager=$manager
  [ $repository_manager ] && break
done

case $manager in
  yum|dnf) update_command="$manager check-update";;
  apt|apt-get) update_command="$manager update";;
  *) echo "Repository Manager Not found"; exit 1;;
esac

nmcli radio wifi on

i=1
aps=0
while [ $i -ne 0 ]; do
  nmcli device wifi rescan ifname "${interface}" > /dev/null 2>&1 \
    && aps=$(nmcli --terse device wifi list ifname $interface | wc -l)

  [ $aps -gt 1 ] && i=0
done

nmcli device connect $interface --ask

nmcli --fields 'DEVICE,STATE' --terse device status \
  | grep -E "^${interface}" \
  | cut -d ':' -f 2 \
  | xargs -I '{}' [ 'connected' = '{}' ] \
  && sudo $update_command

find $HOME/.ssh/ -type f \
  \( -perm 'u=rw-,go=---' -and ! -name 'authorized_keys' \) \
  -exec ssh-add {} \;
