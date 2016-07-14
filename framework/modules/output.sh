if [[ -z "$__MONKEYDIR__" ]]; then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
    exit 1
fi

. "$__MONKEYDIR__"/modules/submodules/coloration.sh
. "$__MONKEYDIR__"/modules/submodules/tell.sh
. "$__MONKEYDIR__"/modules/submodules/errors.sh
. "$__MONKEYDIR__"/modules/submodules/cursor.sh
