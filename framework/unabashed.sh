#!/usr/bin/env bash
# Include this file to gain access to all the unabashed features

__UNABASHEDDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
__UA_ERRORS__=()
__UA_OS_VERSION__=""
__UA_OS_NAME__="unknown"


if hash lsb_release 2>/dev/null; then
  __UA_OS_VERSION__=$(lsb_release -sr)
  __UA_OS_NAME__=$(lsb_release -sd)
fi


__internal_unabashed_preload_error_handler() {
  if [ -z "$1" ]; then
    eval "$FUNCNAME \"Usage: $FUNCNAME [error_message]\""
    printf "   Line: "
    caller
    exit 1 
  fi

  . "$__UNABASHEDDIR__"/modules/submodules/coloration.sh

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


__internal_unabashed_dependency_not_met() {
  if [[ -z "$1" ]]; then
    __internal_unabashed_preload_error_handler "Usage: $FUNCNAME [dependency]"
    exit 1
  fi

  __internal_unabashed_preload_error_handler "unabashed requires $1 to work."
  exit 1
}


__internal_unabashed_load_dependencies() {
  if [[ -z "$1" ]]; then
      __internal_unabashed_preload_error_handler "Usage: $FUNCNAME [directory_path]"
  fi

  local SKIP=(config.sh helpers.sh)

  . "$__UNABASHEDDIR__"/modules/helpers.sh

  if [[ ! -d "$1" ]]; then
    __internal_unabashed_preload_error_handler "$1 is not a directory."
  fi

  for file in `find "$1" -maxdepth 1 -name '*.sh'`; do
    if (! helpers__in_array $(basename "$file") "${SKIP[@]}"); then
      . "$file"
    fi
  done
  
  . "$__UNABASHEDDIR__"/modules/config.sh
}


__internal_unabashed_dependencies=("php")


for __internal_unabashed_dependency in "${__internal_unabashed_dependencies[@]}"; do 
  command -v "$__internal_unabashed_dependency" >/dev/null 2>&1 || __internal_unabashed_dependency_not_met "$__internal_unabashed_dependency"
done

# load modules
__internal_unabashed_load_dependencies "$__UNABASHEDDIR__"/modules/
# load constants
__internal_unabashed_load_dependencies "$__UNABASHEDDIR__"/constants/
