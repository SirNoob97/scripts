#!/bin/bash

find $1 -type d -name '.git' \( -path '*/.git' \) -prune -printf '%h\n'
