#!/usr/bin/env bash

__DIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

if [[ ! -f "$__DIR__"/framework/monkey-wrench.sh ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m The monkey-wrench framework is required. \e[39m\n"
  exit 1
fi

. "$__DIR__"/framework/monkey-wrench.sh


usage() {
  SCRIPTNAME=$(basename "$0")
  tellTitle "USAGE:"
  tellMessage "<comment>$SCRIPTNAME</comment>"
  tellMessage "Run with default options set.\n"
  tellMessage "<comment>$SCRIPTNAME -s|--silent</comment>"
  tellMessage "Runs the script in silence mode -- no output is displayed.\n"
  tellMessage "<comment>$SCRIPTNAME -h[--help]</comment>"
  tellMessage "Display this usage dialog."

  exit 1
}


tellFancyTitle "A cool monkey-wrench slogan will one day come appear here" "INSTALL monkey-wrench" "fg=white;bg=c_55"
params="$(getopt -o sh -l silent,help --name "$(basename "$0")" -- "$@")"

if [ $? != 0 ]; then
    usage
fi

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
    

if [[ ! -d "/usr/local/lib/monkey-wrench" ]]; then
  sudo ln -s ~/Dropbox/singularity/scripts/monkey-wrench /usr/local/lib/monkey-wrench
fi

if [[ ! -f "/usr/local/bin/monkey-wrench" ]]; then
  sudo ln -s ~/Dropbox/singularity/scripts/monkey-wrench/monkey-wrench.sh /usr/local/bin/monkey-wrench
fi

PHP="sudo apt-get -y install php7.0-cli"

if [[ "$SILENT" == false ]]; then
  echo "Installing monkey-wrench library..."
  eval $PHP
  echo "monkey-wrench has been successfully installed!"
else
  eval $PHP > /dev/null
fi
