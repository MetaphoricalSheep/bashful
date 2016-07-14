if [[ -z "$__MONKEYDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
  exit 1
fi


mw::email.__internal_validate_params() {
  require_parameter_count "$FUNCNAME" "$LINENO" 3 "$#"

  local _value
  local _field
  local _lineno
  local _scriptname

  _value="$1"; shift
  _field="$1"; shift
  _lineno="$1"; shift
  _scriptname=$(basename "${BASH_SOURCE[0]}")
        
  if empty "$_field"; then
    __MW_ERRORS__+=("($_scriptname::$_lineno) <comment>Email</> $_field cannot be empty")
    print_fail
    return 1
  fi

  return 0
}


mw::email.send_mail() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"

  local _subject
  local _messsage
  local _html
  local _to
  local _from
  local _verbose
  local _quiet
  local _flags

  _subject="$1"; shift
  _message="$1"; shift

  _html=${1:-}
  _to="$mailgun__to_name <$mailgun__to_email>"
  _to=${2:-$_to}
  _from="$mailgun__from_name <$mailgun__from_email>"
  _from=${3:-$_from}
  _verbose=${__VERBOSE__:-true}
  _quiet=${__QUIET__:-false}

  mw::email.__internal_validate_params "$_to" "to address" "$LINENO"
  mw::email.__internal_validate_params "$_from" "from address" "$LINENO"
  mw::email.__internal_validate_params "$mailgun__server" "server" "$LINENO"
  mw::email.__internal_validate_params "$mailgun__key" "api key" "$LINENO"

  if [[ "$_verbose" == false ]] || [[ "$_quiet" == true ]]; then
    curl -s --user "api:$mailgun__key" \
      "$mailgun__server" \
      -F from="$_from" \
      -F to="$_to" \
      -F subject="$_subject" \
      -F html=" $_html " \
      -F text="$_message" > /dev/null
  else
    curl --user "api:$mailgun__key" \
      "$mailgun__server" \
      -F from="$_from" \
      -F to="$_to" \
      -F subject="$_subject" \
      -F html=" $_html " \
      -F text="$_message"
  fi
}
