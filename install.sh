#!/bin/bash

export install_dir="${1:-$HOME/.local/bin}"

[ ! -d $install_dir ] && mkdir -p $install_dir

function __install {
  for s in $1; do
    name=$(basename $s)
    ln --force --symbolic $s $install_dir/${name%.sh}
  done
}

export -f __install

scripts=$(find $PWD -path */postgresql -prune -o -type f -perm '-u=x' \( -name '*.sh' -not -name '*backup*' -not -name '*install*' \) -printf "%h/%f\n")
