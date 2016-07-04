#!/usr/bin/env bash
# Include this file to gain access to all monkey-wrench features

__MONKEYDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
__MW_OS_VERSION__=$(lsb_release -sr)
__MW_OS_NAME__=$(lsb_release -sd)
__MW_ERRORS__=()

__internal_monkey_preload_error_handler() {
    if [ -z "$1" ]; then
        eval "$FUNCNAME \"Usage: $FUNCNAME [error_message]\""
        printf "   Line: "
        caller
        exit 1 
    fi

    . "$__MONKEYDIR__"/modules/submodules/coloration.sh

    local __msg="  $1  "; shift
    local __space=""

    for i in `seq 1 ${#__msg}`; do
        __space="$__space"" "
    done

    local __final
    __final="\n${c256_b[196]}          $normal${c256_b[255]}$__space$normal\n"
    __final="$__final${c256[255]}${c256_b[196]}  ERROR:  $normal${c256[238]}${c256_b[255]}$__msg$normal\n"
    __final="$__final${c256_b[196]}          $normal${c256_b[255]}$__space$normal\n"

    echo -e "$__final"

    exit 1
}

__internal_monkey_dependency_not_met() {
    if [[ -z "$1" ]]
    then
        __internal_monkey_preload_error_handler "Usage: $FUNCNAME [dependency]"

        exit 1
    fi

    __internal_monkey_preload_error_handler "monkey-wrench requires $1 to work."

    exit 1
}

__internal_monkey_load_dependencies() {
    if [[ -z "$1" ]]
    then
        __internal_monkey_preload_error_handler "Usage: $FUNCNAME [directory_path]"
    fi

    if [[ ! -d "$1" ]]
    then
        __internal_monkey_preload_error_handler "$1 is not a directory."
    fi

    for file in `find "$1" -maxdepth 1 -name '*.sh'`
    do
        . "$file"
    done
}

__internal_monkey_dependencies=("php")

for __internal_monkey_dependency in "${__internal_monkey_dependencies[@]}"
do 
    command -v "$__internal_monkey_dependency" >/dev/null 2>&1 || __internal_monkey_dependency_not_met "$__internal_monkey_dependency"
done

# load modules
__internal_monkey_load_dependencies "$__MONKEYDIR__"/modules/
# load constants
__internal_monkey_load_dependencies "$__MONKEYDIR__"/constants/
