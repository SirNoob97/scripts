#!/bin/bash

__list_not_found_units() {
  systemctl list-units --no-pager --no-legend --all --state not-found \
    | awk '{print $1}'
}

__list_all_units() {
  systemctl list-unit-files --no-pager --no-legend --all \
    | awk '{if(length($1) > 1) print $1}'
}

__list_services_that_need_daemon_reload() {
  systemctl status $1 2>&1 | grep 'systemctl daemon-reload' \
    | awk '{if(length($11) > 1) print $11}'
}


echo "---Units that need a daemon reload---"
for unit in $(__list_all_units); do
  __list_services_that_need_daemon_reload $unit
done

echo -e "\n---Not found units---"
 __list_not_found_units $unit_type
