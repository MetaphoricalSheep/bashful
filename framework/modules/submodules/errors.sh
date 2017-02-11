if [[ -z "$__BASHFULDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source bashful.sh. \e[39m\n"
  exit 1
fi


bf_show_errors() {
  __BF_ERRORS__=${__BF_ERRORS__:-}

  if ! empty $__BF_ERRORS__; then
    local _e
    tellError  "Script execution errors" "ERRORS:"

    for _e in "${__BF_ERRORS__[@]}"; do
      #tellError "$_e"
      >&2 tellMessage "  - $_e"
    done
  fi
}
