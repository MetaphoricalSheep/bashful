#!/usr/bin/env bash

if [[ -z "$__MONKEYDIR__" ]]
then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
    exit 1
fi

mw_move_cursor_up() {
    local _line
    empty "$1" && _line=1 || _line="$1"; shift
    echo -en "\033[$_line"A
}

mw_move_cursor_down() {
    local _line
    empty "$1" && _line=1 || _line="$1"; shift
    echo -en "\033[$_line"B
}

mw_move_cursor_forward() {
    local _col
    empty "$1" && _col=1 || _col="$1"; shift
    echo -en "\033[$_col"C
}

mw_move_cursor_backward() {
    local _col
    empty "$1" && _col=1 || _col="$1"; shift
    echo -en "\033[$_col"D
}

mw_set_cursor_pos() {
    local _line
    local _col
    empty "$1" && _line=0 || _line="$1"; shift
    empty "$1" && _col=0 || _col="$1"; shift
    echo -en "\033[$_line;$_col"H
}

# Clears the screen and moves cursor to (0,0)
mw_clear_screen() {
    echo -en "\033[2J"
}

mw_erase_eol() {
    echo -en "\033[K"
}

mw_save_cursor_pos() {
    echo -en "\033[s"
}

mw_restore_cursor_pos() {
    echo -en "\033[u"
}
