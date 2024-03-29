#!/bin/env bash

set -eu

export install_dir="${1:-${HOME}/.local/bin}"

[ ! -d $install_dir ] && mkdir -p $install_dir

function __install {
  for s in $1; do
    name=$(basename $s)
    ln --force --symbolic $s $install_dir/${name%.sh}
  done
}

export -f __install

find $PWD \( -path */postgresql -o -path */java/binfmt_msc \) \
     -prune \
     -o \
     -type f \
     -perm '-u=x' \
     \( -name '*.sh' -not -name '*backup*' -not -name '*install*' -not -name '*test*' \) \
     -exec bash -c '__install {}' \;
