#!/bin/bash

winterface=""
einterface=""
binterface=""

# apt update
# apt install --no-install-recommends --no-install-suggests bridge-utils qemu qemu-system-x86 qemu-utils libvirt-daemon-system virt-manager

# brctl addbr $binterface

# echo "Creating /etc/network/interfaces backup..."
# cp /etc/network/interfaces /etc/network/interfaces.bak
# echo "/etc/network/interfaces backup done."
# echo "See /etc/network/interfaces.bak"

# cat >> /etc/network/interfaces <<EOF

# # The bridge network interface
# auto ${binterface}
# iface ${binterface} inet dhcp
# bridge_ports ${winterface} ${einterface}
# EOF

# systemctl restart networking.service
