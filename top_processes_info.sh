#!/bin/bash

top_flags="-bcs -o %CPU -u "$(whoami)" -n 1 -w 512"
top_cmd="top ${top_flags}"
awk_pattern='
BEGIN {
    pids_command = "pidstat -dlurv -p %s --human"
}
{
  if($0 !~ top_cmd && NR <= 20) {
    print $0
    first[NR] = $1 ""
  }

  if($1 == "PID") start = NR + 1
}
END {
  for(i = start; i <= start + 5; i++) {
    pids = (pids first[i]",")
  }

  gsub(",$", "", pids)
  print("")
  system(sprintf(pids_command, pids))
}
'

$top_cmd | awk -v "top_cmd=$top_cmd" "$awk_pattern"
