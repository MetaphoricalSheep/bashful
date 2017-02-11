if [[ -z "$__BASHFULDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source bashful.sh. \e[39m\n"
  exit 1
fi

. "$__BASHFULDIR__"/modules/submodules/email.sh

