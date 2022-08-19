#!/bin/env bash

set -eu -o pipefail

top_flags="-bcs -o %CPU -u $(whoami) -n 1 -w 512"
pidstat_flags="-dlurv -p %s --human"
pidstat_cmd="pidstat ${pidstat_flags}"
top_cmd="top ${top_flags}"
awk_pattern='
{
  if($0 !~ top_cmd && NR <= 21) {
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
  system(sprintf(pid_cmd, pids))
}
'

$top_cmd | awk -v "top_cmd=${top_cmd}" -v "pid_cmd=${pidstat_cmd}" "${awk_pattern}"
