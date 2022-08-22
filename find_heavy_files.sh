#!/bin/env bash

# Simple script to list files of directories heavier than 1G

set -eu -o pipefail

path=${1:-$PWD}

[ -d $path ] || echo "Parent directory not found"

find $path \
     -maxdepth 1 \
     -mindepth 1 \
     \( -type d -or -type f \) \
     -readable \
     -execdir du -sht 1G {} 2> /dev/null + | \
    sort -h
