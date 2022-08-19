#!/bin/env bash

set -eu -o pipefail

directory="${1:-${HOME}/.local/share/fonts/}"
awk_pattern='
BEGIN {
  FS = ":"
}
{
  line[NR] = $2
}
END{
  isort(line, NR)
  filter(line)
} 

function filter(A, hold) {
  for(l in A) {
    hold[A[l]] = ""
  }
  
  for(name in hold) print name
}

function isort(A, n, i, j, hold) {
  for(i = 2; i <= n; i++){
    hold = A[j = i]
    while(A[j-1] > hold){
      j--
      A[j + 1] = A[j]
    } A[j] = hold
  }
}
'
echo -e "Available fonts installed in ${directory}\n"
fc-list | grep "${directory}" | awk "${awk_pattern}" | grep -vE '^$|[iI]con[s]'
