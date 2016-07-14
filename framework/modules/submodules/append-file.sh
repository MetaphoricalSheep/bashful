if [[ -z "$__MONKEYDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
  exit 1
fi

#
# Appends file n lines from bottom of file
# 
append_file() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"

  local _data
  local _line
  local _tmpfile
  local _file

  _line=1
  _tmpfile=/tmp/$(date +%s)

  _file="$1"; shift
  _data="$1"; shift

  if ! empty "$1" && is_number "$1"; then
    _line="$1"; shift
  fi

  if ! file_exists "$_file"; then
    tellError "$_file does not exist."
    exit 1
  fi

  head --lines=-"$_line" "$_file" > "$_tmpfile"
  echo "$_data" >> "$_tmpfile"
  tail --lines="$_line" "$_file" >> "$_tmpfile"

  mv "$_tmpfile" "$_file"
}
