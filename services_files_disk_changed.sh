#!/bin/bash

# list the services, sockets or timers that need a daemon reload

echo "---Services---"
for s in $(systemctl list-unit-files | grep 'enabled' | grep '.service' | awk '{print $1}'); do
  systemctl status $s 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
done

echo -e "\n---Sockets---"
for s in $(systemctl list-unit-files | grep 'enabled' | grep '.socket' | awk '{print $1}'); do
  systemctl status $s 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
done

echo -e "\n---Timers---"
for s in $(systemctl list-unit-files | grep 'enabled' | grep '.timer' | awk '{print $1}'); do
  systemctl status $s 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
done
