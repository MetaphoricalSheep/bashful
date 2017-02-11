if [[ -z "$__UNABASHEDDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
  exit 1
fi


ua_show_errors() {
  __UA_ERRORS__=${__UA_ERRORS__:-}

  if ! helpers__empty $__UA_ERRORS__; then
    local _e
    tellError  "Script execution errors" "ERRORS:"

    for _e in "${__UA_ERRORS__[@]}"; do
      #tellError "$_e"
      >&2 tellMessage "  - $_e"
    done
  fi
}
