#!/usr/bin/env bash
# Include this file to gain access to all the bashful features

__BASHFULDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
__BF_ERRORS__=()
__BF_OS_VERSION__=""
__BF_OS_NAME__="unknown"


if hash lsb_release 2>/dev/null; then
  __BF_OS_VERSION__=$(lsb_release -sr)
  __BF_OS_NAME__=$(lsb_release -sd)
fi


__internal_bashful_preload_error_handler() {
  if [ -z "$1" ]; then
    eval "$FUNCNAME \"Usage: $FUNCNAME [error_message]\""
    printf "   Line: "
    caller
    exit 1 
  fi

  . "$__BASHFULDIR__"/modules/submodules/coloration.sh

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


__internal_bashful_dependency_not_met() {
  if [[ -z "$1" ]]; then
    __internal_bashful_preload_error_handler "Usage: $FUNCNAME [dependency]"
    exit 1
  fi

  __internal_bashful_preload_error_handler "bashful requires $1 to work."
  exit 1
}


__internal_bashful_load_dependencies() {
  if [[ -z "$1" ]]; then
      __internal_bashful_preload_error_handler "Usage: $FUNCNAME [directory_path]"
  fi

  if [[ ! -d "$1" ]]; then
    __internal_bashful_preload_error_handler "$1 is not a directory."
  fi

  for file in `find "$1" -maxdepth 1 -name '*.sh'`; do
    . "$file"
  done
}


__internal_bashful_dependencies=("php")


for __internal_bashful_dependency in "${__internal_bashful_dependencies[@]}"; do 
  command -v "$__internal_bashful_dependency" >/dev/null 2>&1 || __internal_bashful_dependency_not_met "$__internal_bashful_dependency"
done

# load modules
__internal_bashful_load_dependencies "$__BASHFULDIR__"/modules/
# load constants
__internal_bashful_load_dependencies "$__BASHFULDIR__"/constants/
