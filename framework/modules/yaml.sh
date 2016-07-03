#!/usr/bin/env bash

if [[ -z "$__MONKEYDIR__" ]]
then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
    exit 1
fi

# sourced from <https://gist.github.com/epiloque/8cf512c6d64641bde388>
# Based on https://gist.github.com/pkuczynski/8665367

parse_yaml() {
    local prefix=$2
    local s
    local w
    local fs
    s='[[:space:]]*'
    w='[a-zA-Z0-9_]*'
    fs="$(echo @|tr @ '\034')"
    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$1" |
    awk -F"$fs" '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
            if (length($3) > 0) {
                vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                printf("%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, $3);
            }
    }' | sed 's/_=/+=/g'
}
