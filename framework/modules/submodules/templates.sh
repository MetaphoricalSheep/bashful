if [[ -z "$__UNABASHEDDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
  exit 1
fi
    

unabashed::templates::__internal_format_data() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"

  local _value
  local _action
  local _word

  _value="$1"; shift
  _action="$1"; shift

  case "$_action" in
    capitalize)
      echo -n "${_value^}"
      return 0
      ;;
    lower)
      echo -n "${_value,,}"
      return 0
      ;;
    title)
      for _word in "$_value"; do 
        printf '%s ' "${_word^}"; 
      done
      return 0
      ;;
    upper)
      echo -n "${_value^^}"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}


unabashed::templates::parse_template() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"

  local _template
  local _template_data
  local _data
  local _matches
  local _match
  local _var
  local _value
  local _action
  local _segments
  local _old_ifs
  local _tmp_data
  local _pmatch

  _template="$1";shift
  if ! is_file "$_template"; then
    local _scriptname
    _scriptname=$(basename "${BASH_SOURCE[0]}")
    __UA_ERRORS__+=("($_scriptname::$LINENO) <comment>$_template</> is not a file.")
    print_fail
    return 1
  fi
    
  declare -a _tmp_data=("${@:1}")
  declare -A _data
  _old_ifs="$IFS"

  for _item in "${_tmp_data[@]}"; do
    IFS="$OLDIFS"
    _segments=(${_item//=/ })
    IFS="$_old_ifs"
    _data["${_segments[0]}"]="${_segments[@]:1}"
  done

  _data["__internal__random__"]=z$(unix_timestamp)z
  _template_data=$(echo $(cat "$_template"))

  for _match in $(grep -Po "{{.*?}}" "$_template"); do
    _pmatch=${_match#\{\{}
    _pmatch=${_pmatch%\}\}}
    # The strict mode IFS breaks the array assignment
    # Revert for this to work
    IFS="$OLDIFS"
    _segments=(${_pmatch//|/ })
    IFS="$_old_ifs"
    _var="${_segments[0]}"
    _value=${_data[$_var]}

    if [[ "${#_segments}" > 1 ]]; then
      for _action in "${_segments[@]:1}"; do
        _value=$(unabashed::templates::__internal_format_data "$_value" "$_action")
      done
    fi

    _template_data=${_template_data//$_match/$_value}
  done

  echo "$_template_data"
  return 0
}
