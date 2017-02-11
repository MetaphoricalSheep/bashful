#!/usr/bin/env bash

__BASHFULDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
. "$__BASHFULDIR__"/framework/bashful.sh


usage() {
  tellMessage "<info>Usage</>"
  tellMessage "<comment>bashful [action] [project-dir]</>"
  tellMessage "Creates a new bashful project at the specified directory."

  exit 1
}


main() {
  tellFancyTitle "Manage your bashful projects." "bashful:" "fg=white;bg=c_208"

  if bashful__helpers__empty "$1" || bashful__helpers__empty "$2"; then
    usage
  fi

  local _action="$1"; shift
  local _project="main"
  local _project_dir="$1"; shift
  local _actions=("new" "update")

  if ! bashful__helpers__empty "$1"; then
    _project="$1"; shift
  fi

  if ! in_array "$_action" "${_actions[@]}"; then
    tellError "$_action is not a valid action."

    exit 1
  fi

  eval "${_action}" "$_project_dir" "$_project"
}


update_script() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  tellMessage "<info>Creating bashful update helper script...</>"

  cat << proj > "$_project_dir/update-bashful"
#!/usr/bin/env bash

__DIR__=\$(dirname \$(readlink -f "\${BASH_SOURCE[0]}"))

bashful update  "\$__DIR__" "$_project"
proj
    
  tellMessage "<info>Making update helper executable...</>"
  chmod +x "$_project_dir/update-bashful"
}


new_script() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  tellMessage "<info>Creating project script...</>"

  cat << proj >> "$_project_dir/$_project".sh
#!/usr/bin/env bash

# Your project description here

# Enable unofficial strict mode
set -euo pipefail
IFS=$'\n\t'


# Including bashful framework
__DIR__=\$(dirname \$(readlink -f "\${BASH_SOURCE[0]}"))
. "\$__DIR__"/bashful/bashful.sh


__PROJECT__=$_project


usage() {
  tellMessage "<info>Usage</>"
  tellMessage "<comment>\$__PROJECT__ <param> [param]"
  tellMessage "Your usage instrunctions should come here."

  exit 1
}


eval set -- "$params"
unset params

SILENT=false

while true; do
  case "$1" in
    -s|--silent)
      SILENT=true
      shift
      break;;
    -h|--help)
      usage
      shift
      break;;
    --)
      shift
      break;;
    *)
      usage
      break;;
  esac
  shift
done


main() {
  tellFancyTitle "A new bashful project." "\$__PROJECT__" "fg=white;bg=c_22"
}


main "\$@"
proj
    
  tellMessage "<info>Making project script executable...</>"
  chmod +x "$_project_dir/$_project".sh
}


install() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift

  tellMessage "<info>Project Name</>: <comment>$_project</>"
  tellMessage "<info>Project Dir</> : <comment>$_project_dir</>"
  tellMessage "<info>Installing bashful files...</>"

  if directory_exists "$_project_dir"/bashful; then
    rm -r "$_project_dir"/bashful
  fi

  cp "$__BASHFULDIR__" "$_project_dir"/bashful -R
}

update() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  if ! directory_exists "$_project_dir"; then
    tellError "The project directory $_project_dir does not exist. Nothing to update."
    exit 1
  fi

  if bashful__helpers__empty_dir "$_project_dir"; then
    tellError "The project directory $_project_dir is bashful__helpers__empty. Nothing to update."
    exit 1
  fi

  install "$_project_dir" "$_project"
  update_script "$_project_dir" "$_project"
}


new() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  if ! directory_exists "$_project_dir"; then
    mkdir -p "$_project_dir"
  fi

  if ! bashful__helpers__empty_dir "$_project_dir"; then
    tellError "The project directory $_project_dir is not bashful__helpers__empty."
    exit 1
  fi

  install "$_project_dir" "$_project"
  update_script "$_project_dir" "$_project"
  new_script "$_project_dir" "$_project"
}


main "$@"
