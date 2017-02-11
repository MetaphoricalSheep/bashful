#!/usr/bin/env bash

__UNABASHEDDIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
. "$__UNABASHEDDIR__"/framework/unabashed.sh


usage() {
  tellMessage "<info>Usage</>"
  tellMessage "<comment>unabashed [action] [project-dir]</>"
  tellMessage "Creates a new unabashed project at the specified directory."

  exit 1
}


main() {
  tellFancyTitle "Manage your unabashed projects." "unabashed:" "fg=white;bg=c_208"

  if helpers__empty "$1" || helpers__empty "$2"; then
    usage
  fi

  local _action="$1"; shift
  local _project="main"
  local _project_dir="$1"; shift
  local _actions=("new" "update")

  if ! helpers__empty "$1"; then
    _project="$1"; shift
  fi

  if ! helpers__in_array "$_action" "${_actions[@]}"; then
    tellError "$_action is not a valid action."

    exit 1
  fi

  eval "${_action}" "$_project_dir" "$_project"
}


update_script() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  tellMessage "<info>Creating unabashed update helper script...</>"

  cat << proj > "$_project_dir/update-unabashed"
#!/usr/bin/env bash

__DIR__=\$(dirname \$(readlink -f "\${BASH_SOURCE[0]}"))

unabashed update  "\$__DIR__" "$_project"
proj
    
  tellMessage "<info>Making update helper executable...</>"
  chmod +x "$_project_dir/update-unabashed"
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


# Including unabashed framework
__DIR__=\$(dirname \$(readlink -f "\${BASH_SOURCE[0]}"))
. "\$__DIR__"/.unabashed/unabashed.sh


__PROJECT__=$_project


usage() {
  tellMessage "<info>Usage</>"
  tellMessage "<comment>\$__PROJECT__ <param> [param]"
  tellMessage "Your usage instrunctions should come here."

  exit 1
}

tellFancyTitle "A new unabashed project." "\$__PROJECT__" "fg=white;bg=c_22"

params="\$(getopt -o sh -l silent,help --name "\$(basename "\$0")" -- "\$@")"

if [ \$? != 0 ]; then
    usage
fi


eval set -- "\$params"
unset params

SILENT=false

while true; do
  case "\$1" in
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
  tellMessage "<info>Installing unabashed files...</>"

  if directory_exists "$_project_dir"/.unabashed; then
    rm -r "$_project_dir"/.unabashed
  fi
  
  if directory_exists "$_project_dir"/.unabashed/config; then
    rsync -azq --ignore-existing "$__UNABASHEDDIR__"/../config "$_project_dir"/config 
    rsync -azq "$__UNABASHEDDIR__"/../config/*.default.*.yml "$_project_dir"/config/
  else
    cp "$__UNABASHEDDIR__"/../config "$_project_dir"/config -R
  fi

  cp "$__UNABASHEDDIR__" "$_project_dir"/.unabashed -R
}

update() {
  require_parameter_count "$FUNCNAME" "$LINENO" 2 "$#"
  local _project_dir="$1"; shift
  local _project="$1"; shift
    
  if ! directory_exists "$_project_dir"; then
    tellError "The project directory $_project_dir does not exist. Nothing to update."
    exit 1
  fi

  if helpers__empty_dir "$_project_dir"; then
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

  if ! helpers__empty_dir "$_project_dir"; then
    tellError "The project directory $_project_dir is not empty."
    exit 1
  fi

  install "$_project_dir" "$_project"
  update_script "$_project_dir" "$_project"
  new_script "$_project_dir" "$_project"
}


main "$@"
