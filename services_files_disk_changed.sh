#!/bin/bash

# list the services that need a daemon reload

for s in $(systemctl list-unit-files | grep 'enabled' | grep '.service' | awk '{print $1}'); do
  systemctl status $s 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
done
