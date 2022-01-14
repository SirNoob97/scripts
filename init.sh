#!/bin/bash

set -o pipefail

interface='wlp2s0'


nmcli radio wifi on

i=1
APS=0
while [ $i -ne 0 ]; do
  nmcli device wifi rescan ifname "$interface" > /dev/null 2>&1 \
    && APS=$(nmcli --terse device wifi list ifname $interface | wc -l)

  [ $APS -gt 1 ] && i=0
done

nmcli device connect $interface --ask

nmcli --fields 'DEVICE,STATE' --terse device status \
  | grep -E "^$interface" \
  | cut -d ':' -f 2 \
  | xargs -I '{}' [ 'connected' = '{}' ] \
  && sudo $update_command
