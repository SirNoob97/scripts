#!/bin/bash

apt update && \
    apt install --no-install-recommends --no-install-suggests -y bridge-utils qemu qemu-system-x86 qemu-utils libvirt-daemon-system virt-manager
