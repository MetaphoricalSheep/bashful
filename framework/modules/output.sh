if [[ -z "$__UNABASHEDDIR__" ]]; then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
    exit 1
fi

. "$__UNABASHEDDIR__"/modules/submodules/coloration.sh
. "$__UNABASHEDDIR__"/modules/submodules/tell.sh
. "$__UNABASHEDDIR__"/modules/submodules/errors.sh
. "$__UNABASHEDDIR__"/modules/submodules/cursor.sh
