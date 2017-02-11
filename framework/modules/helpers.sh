if [[ -z "$__UNABASHEDDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
  exit 1
fi


is_number() {
  helpers__empty "$1" && return 1
  local _num="$1"; shift
  local _re='^[0-9]+$'
  ! [[ $_num =~ $_re ]] && return 1

  return 0
}


is_array() {
  # Call by using is_array array_name;
  # NOT is_array $array_name
  helpers__empty "$1" && return 1
  declare -p ${1} 2> /dev/null | grep 'declare \-a' >/dev/null && return 0

  return 1
}


file_exists() {
  helpers__empty "$1" && return 1
  local _file="$1"; shift
  [ -f "$_file" ] && return 0

  return 1
}


is_file() {
  file_exists "$1" && return 0
  return 1
}


helpers__empty() {
  local _var
  _var=${1:-}
  [ -z "$_var" ] && return 0

  return 1
}


dir_exists() {
  helpers__empty "$1" && return 1
  [ -d "$1" ] && return 0

  return 1
}


directory_exists() {
  dir_exists "$1" && return 0 || return 1
}


is_dir() {
  dir_exists "$1" && return 0 || return 1
}


is_directory() {
  dir_exists "$1" && return 0 || return 1
}


check_root() {
  if [[ $EUID -ne 0 ]]; then
    local _msg
    _msg=${1:-"This script requires root access"}
    tellError "$_msg"

    exit 1
  fi
}


helpers__in_array() {
  helpers__empty "$1" && return 1
  helpers__empty "$2" && return 1
    
  local _needle
  _needle="$1"
  local _e

  for _e in "${@:2}"; do 
    [[ "$_e" == "$_needle" ]] && return 0
  done
    
  return 1
}


function_exists() {
  helpers__empty "$1" && return 1
  local _function="$1"; shift

  if ! helpers__empty $(type -t "$_function"); then
    return 0
  fi

  return 1
}


helpers__empty_dir() {
  require_parameter_count "$FUNCNAME" "$LINENO" 1 "$#"

  local _dir="$1"; shift

  if ! is_directory "$_dir"; then
    tellError "helpers__empty_dir requires a directory as parameter."
    printf "   Line: "
    caller
    exit 1 
  fi


  [ "$(ls -A "$_dir")" ] && return 1 || return 0
}


require_parameter_count() {
  if helpers__empty "$1" || helpers__empty "$2" || helpers__empty "$3" || helpers__empty "$4"; then
    tellError "Usage: require_parameter_count [func] [lineno] [required_count] [actual_count]"
    printf "   Line: "
    caller
    exit 1 
  fi

  local _func="$1"; shift
  local _lineno="$1"; shift
  local _required="$1"; shift
  local _actual="$1"; shift

  if [[ "$_actual" < "$_required" ]]; then
    tellError "$_func::$_lineno requires at least $_required parameters."
    printf "   Line: "
    caller
    exit 1 
  fi
}


unix_timestamp() {
  local _timestamp
  _timestamp=$(date +%s)
  echo "$_timestamp"
  return 0
}
