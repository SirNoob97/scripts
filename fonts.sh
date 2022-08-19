#!/bin/env bash

set -eu -o pipefail

DIRECTORY="${1:-$HOME/.local/share/fonts/}"
AWK_PATTERN='
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
echo -e "Available fonts installed in $DIRECTORY\n"
fc-list | grep "$DIRECTORY" | awk "$AWK_PATTERN" | grep -vE '^$|[iI]con[s]'
