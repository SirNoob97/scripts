#!/bin/bash

__list_not_found_units() {
  systemctl list-units --no-pager --no-legend --all --type $1 --state not-found \
    | awk '{print $1}'
}

__list_enabled_units() {
  systemctl list-unit-files --no-pager --no-legend --all --type $1 --state enabled \
    | awk '{print $1}'
}

__list_services_that_need_daemon_reload() {
  systemctl status $1 2>&1 | grep 'systemctl daemon-reload' | awk '{print $11}'
}


for unit_type in "service" "socket" "timer"; do
  echo "---${unit_type^}s---"
  for unit in $(__list_enabled_units "$unit_type"); do
    __list_services_that_need_daemon_reload $unit
  done
  echo -e "\n---Not found ${unit_type}s---"
  __list_not_found_units $unit_type
  echo ""
done
