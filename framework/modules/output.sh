#!/usr/bin/env bash

if [[ -z "$__MONKEYDIR__" ]]
then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
    exit 1
fi

. "$__MONKEYDIR__"/modules/submodules/coloration.sh
. "$__MONKEYDIR__"/modules/submodules/tell.sh
