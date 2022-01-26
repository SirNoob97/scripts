#!/bin/bash

# TODO:// extract enabled units function
# list the services, sockets or timers that need a daemon reload

__list_units() {
  echo $1 $2
  systemctl list-units --no-pager --no-legend --all --type $1 --state $2 \
    | awk '{print $1}'
}

__list_services_that_need_daemon_reload() {
  systemctl status $1 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
}


for ut in "service" "socket" "timer"; do
  echo "---${ut^}s---"
  for u in $(__list_units $ut 'enabled'); do
    __list_services_that_need_daemon_reload $u
  done
  echo -e "\n---Not found ${ut}s---"
  __list_units $ut not-found
  echo ""
done
