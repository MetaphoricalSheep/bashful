if [[ -z "$__UNABASHEDDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
  exit 1
fi


ua_move_cursor_up() {
  local _line
  _line=${1:-1}
  echo -en "\033[$_line"A

  return 0
}


ua_move_cursor_down() {
  local _line
  _line=${1:-1}
  echo -en "\033[$_line"B

  return 0
}


ua_move_cursor_forward() {
  local _col
  _col=${1:-1}
  echo -en "\033[$_col"C

  return 0
}


ua_move_cursor_backward() {
  local _col
  _col=${1:-1}
  echo -en "\033[$_col"D

  return 0
}


ua_set_cursor_pos() {
  local _line
  local _col
  _line=${1:-0}
  _col=${2:-0}
  echo -en "\033[$_line;$_col"H

  return 0
}


# Clears the screen and moves cursor to (0,0)
ua_clear_screen() {
  echo -en "\033[2J"
  return 0
}


ua_erase_eol() {
  echo -en "\033[K"
  return 0
}


ua_save_cursor_pos() {
  echo -en "\033[s"
  return 0
}


ua_restore_cursor_pos() {
  echo -en "\033[u"
  return 0
}
