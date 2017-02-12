if [[ -z "$__UNABASHEDDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
  exit 1
fi


output__cursor__up() {
  local _line
  _line=${1:-1}
  echo -en "\033[$_line"A

  return 0
}


output__cursor__down() {
  local _line
  _line=${1:-1}
  echo -en "\033[$_line"B

  return 0
}


output__cursor__forward() {
  local _col
  _col=${1:-1}
  echo -en "\033[$_col"C

  return 0
}


output__cursor__backward() {
  local _col
  _col=${1:-1}
  echo -en "\033[$_col"D

  return 0
}


output__cursor__set_pos() {
  local _line
  local _col
  _line=${1:-0}
  _col=${2:-0}
  echo -en "\033[$_line;$_col"H

  return 0
}


# Clears the screen and moves cursor to (0,0)
output__cursor__clear_screen() {
  echo -en "\033[2J"
  return 0
}


output__cursor__erase_eol() {
  echo -en "\033[K"
  return 0
}


output__cursor__save_pos() {
  echo -en "\033[s"
  return 0
}


output__cursor__restore_pos() {
  echo -en "\033[u"
  return 0
}
