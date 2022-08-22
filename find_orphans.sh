#!/bin/env bash

set -e

find ${1:-$PWD} \( -nogroup -or -nouser \) -print
