if [[ $_ == $0 ]]; then
  echo "You are not allowed to run this script directly!"
  echo "Run provision-htpc.sh instead"

  exit 1
fi


__internal_load_configs() {
  require_parameter_count "$FUNCNAME" "$LINENO" 1 "$#"

  local _pattern
  local _not_pattern
  local _conf
  local _conf_name
  _pattern="$1"; shift
  _not_pattern=${1:-}

  for _conf in $(find "$__DIR__/config/" -type f -name "$_pattern" -not -name "$_not_pattern"); do
    _conf_name=$(basename "$_conf")
    if [[ "config.yml" != "$_conf_name" ]] && [[ "config.default.yml" != "$_conf_name" ]]; then
      eval $(parse_yaml "$_conf" "__")
    fi
  done
}


main() {
  # load config.default.yml and config.yml first
  eval $(parse_yaml "$__DIR__/config/config.default.yml" "__")
  eval $(parse_yaml "$__DIR__/config/config.yml" "__")

  # Load defaults
  __internal_load_configs "*default.yml"
  # Load overrides
  __internal_load_configs "*.yml" "*default.yml"
}


main
