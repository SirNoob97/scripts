#!/bin/bash

export install_dir="${1:-$HOME/.local/bin}"

[ ! -d $install_dir ] && mkdir -p $install_dir

scripts=$(find $PWD -path */postgresql -prune -o -type f -perm '-u=x' \( -name '*.sh' -not -name '*backup*' -not -name '*install*' \) -printf "%h/%f\n")

for s in $scripts; do
    name=$(basename $s)
    ln --force --symbolic $s $install_dir/${name%.sh}
done
