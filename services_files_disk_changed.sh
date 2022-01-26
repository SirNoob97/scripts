#!/bin/bash

# list the services, sockets or timers that need a daemon reload

__list_enabled_units() {
  systemctl list-unit-files --no-pager --no-legend -at $1 --state enabled \
    | awk '{print $1}'
}

__list_services_that_need_daemon_reload() {
  systemctl status $1 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
}


for ut in "service" "socket" "timer"; do
  echo "---${ut^}s---"
  for s in $(__list_enabled_units $ut); do
    __list_services_that_need_daemon_reload $s
  done
  echo ""
done
