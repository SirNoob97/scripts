#!/bin/env bash

set -eu -o pipefail

data=$(find $PWD -type f | xargs md5sum | awk '{print $1"--"$2}' | sort)

temp_dir=$(mktemp -d --suffix="_dupe_files")

for file_checksum in $data; do
    checksum="${file_checksum%--*}"
    file="${file_checksum#*--}"
    
    if [ -f $temp_dir/$checksum ]; then
        echo "  ${file}" >> $temp_dir/$checksum
    else
        touch $temp_dir/$checksum
        echo "  ${file}" >> $temp_dir/$checksum
    fi
done

for f in $temp_dir/*; do
    [ $(wc -l < "$f") -gt 1 ] && \
        echo -e "Files that share the md5 checksum: ${f##*/}\n" && \
        cat $f && \
        echo ""
done
