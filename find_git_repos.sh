#!/bin/env bash

set -e

find ${1:-$PWD} -type d -name '.git' \( -path '*/.git' \) -prune -printf '%h\n'
