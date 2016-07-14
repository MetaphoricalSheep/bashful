#!/usr/bin/env bash

__MONKEYDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
. "$__MONKEYDIR__"/framework/monkey-wrench.sh


usage() {
  tellMessage "<info>Usage</>"
  tellMessage "<comment>monkey-wrench [action] [project-dir]</comment>"
  tellMessage "Creates a new monkey-wrench project at the specified directory."

  exit 1
}


main() {
  tellFancyTitle "Manage your monkey-wrench projects." "monkey-wrench:" "fg=white;bg=c_208"

  if empty "$1" || empty "$2"; then
    usage
  fi

  local _action="$1"; shift
  local _project="main"
  local _project_dir="$1"; shift
  local _actions=("new" "update")

  if ! empty "$1"; then
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
    
  tellMessage "<info>Creating monkey-wrench update helper script...</>"

  cat << proj > "$_project_dir/update-monkey-wrench"
#!/usr/bin/env bash

__DIR__=\$(dirname \$(readlink -f "\${BASH_SOURCE[0]}"))

monkey-wrench update  "\$__DIR__" "$_project"
proj
    
  tellMessage "<info>Making update helper executable...</>"
  chmod +x "$_project_dir/update-monkey-wrench"
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


# Including monkey-wrench framework
__DIR__=\$(dirname \$(readlink -f "\${BASH_SOURCE[0]}"))
. "\$__DIR__"/monkey-wrench/monkey-wrench.sh


main() {
  tellFancyTitle "A new monkey-wrench project." "$_project" "fg=white;bg=c_22"
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
  tellMessage "<info>Installing monkey wrench files...</>"

  if directory_exists "$_project_dir"/monkey-wrench; then
    rm -r "$_project_dir"/monkey-wrench
  fi

  cp "$__MONKEYDIR__" "$_project_dir"/monkey-wrench -R
}

update() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  if ! directory_exists "$_project_dir"; then
    tellError "The project directory $_project_dir does not exist. Nothing to update."
    exit 1
  fi

  if empty_dir "$_project_dir"; then
    tellError "The project directory $_project_dir is empty. Nothing to update."
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

  if ! empty_dir "$_project_dir"; then
    tellError "The project directory $_project_dir is not empty."
    exit 1
  fi

  install "$_project_dir" "$_project"
  update_script "$_project_dir" "$_project"
  new_script "$_project_dir" "$_project"
}


main "$@"
