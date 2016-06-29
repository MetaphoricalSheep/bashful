#!/usr/bin/env bash
# Include this file to gain access to all monkey-wrench features

__MONKEYDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

for file in `find "$__MONKEYDIR__"/modules/ -maxdepth 1 -name '*.sh'`
do
    . "$file"
done
