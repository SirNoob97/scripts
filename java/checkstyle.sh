#!/bin/env bash

# remember to download from the latest release from the releases section
# https://github.com/checkstyle/checkstyle/releases/tag/checkstyle-8.45.1

java -jar $HOME/.local/bin/checkstyle-8.45.1-all.jar "$@"
