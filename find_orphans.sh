#!/bin/env bash

set -e

find $1 \( -nogroup -or -nouser \) -print
