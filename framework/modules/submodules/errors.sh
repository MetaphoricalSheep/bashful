#!/usr/bin/env bash

if [[ -z "$__MONKEYDIR__" ]]
then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
    exit 1
fi

mw_show_errors() {
    __MW_ERRORS__=${__MW_ERRORS__:-}

    if ! empty $__MW_ERRORS__
    then
        local _e
        tellError  "Script execution errors" "ERRORS:"

        for _e in "${__MW_ERRORS__[@]}"
        do
            #tellError "$_e"
            >&2 tellMessage "  - $_e"
        done
    fi
}
