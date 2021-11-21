#!/bin/env bash

# remember to download from the latest release from the releases section
# https://github.com/google/google-java-format

java -jar $HOME/.local/bin/google-java-format-1.11.0-all-deps.jar "$@"
