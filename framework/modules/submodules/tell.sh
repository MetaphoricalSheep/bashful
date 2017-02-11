# output formatter
if [[ -z "$__UNABASHEDDIR__" ]]; then
  echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source unabashed.sh. \e[39m\n"
  exit 1
fi

col=$(tput cols)

INFO="$blue"
SUCCESS="$green"
WARNING="$yellow"
DANGER="$red"

COMMENT="$yellow"
QUESTION="$cyan"
ERROR="$red"
TITLE=""


format_message() {
  local _msg
  local _no_newline
    
  _msg=${1:-}; shift
  _no_newline=${1:-}

  helpers__empty "$_msg" && return 1
  helpers__empty "$_no_newline" && echo -e $(php "$__UNABASHEDDIR__"/modules/submodules/formatter.php "$_msg") || echo -en $(php "$__UNABASHEDDIR__"/modules/submodules/formatter.php "$_msg")
}


tellFancyTitle() {
  require_parameter_count "$FUNCNAME" "$LINENO" 1 "$#"

  local _title="  $1              "; shift
  local _title_space=""
  local _subtitle
  local _subtitle_space
  local _format
    
  _subtitle=${1:-"TITLE:"}; shift
  _subtitle="  $_subtitle  "
  _subtitle_space=""
  _format=${1:-"question"}

  for i in `seq 1 ${#_subtitle}`; do
    _subtitle_space="$_subtitle_space"" "
  done

  for i in `seq 1 ${#_title}`; do
    _title_space="$_title_space"" "
  done

  local _final="<$_format>$_subtitle_space</><bg=white;fg=black>$_title_space</>\n"
  _final="$_final<$_format>$_subtitle</><bg=white;fg=black>$_title</>\n"
  _final="$_final<$_format>$_subtitle_space</><bg=white;fg=black>$_title_space</>\n"

  format_message "$_final"
}


tellTitle() {
  require_parameter_count "$FUNCNAME" "$LINENO" 1 "$#"

  local _msg
  local _space
  local _format

  _msg=${1:-}; shift
  _space="  "
  _format=${1:"question"}

  for i in `seq 1 ${#_msg}`; do
    _space="$_space"" "
  done

  _space="$_space""  "

  local _final="\n<$_format>$_space\n  $_msg  \n$_space</>\n"

  format_message "$_final"
}


tellMessage() {
  local _msg
  local _no_newline
  _msg=${1:- }
  _no_newline=${2:-}
  helpers__empty "$_no_newline" && format_message "$_msg" || format_message "$_msg" $_no_newline
}


# $1=message    #required
# $2=color all  #default=no
tellError() {
  require_parameter_count "$FUNCNAME" "$LINENO" 1 "$#"

  local MSG=$1
  local SPACE=""

  for i in `seq 1 ${#MSG}`; do
    SPACE="$SPACE"" "
  done

  SPACE="$SPACE""    "

  MSG="\n<bg=c_196>          </><bg=white>$SPACE</>\n"
  MSG="$MSG<fg=white;bg=c_196>  ERROR:  </><fg=c_238;bg=white>  $1  </>\n"
  MSG="$MSG<bg=c_196>          </><bg=white>$SPACE</>\n"
  >&2 format_message "$MSG"
}


# $1=message   #required
# $2=status    #default=SUCCESS
# $3=statusmessage #default based on status
# $4=behaviour #default=echo
tellStatus() {
  if [ -z "$1" ]; then
    tellError "Message (arg1) is required for function \`$FUNCNAME\` on line $LINENO!"
    printf "   Line: "
    caller
    exit $?
  fi

  STATUS="$INFO"
  STATUSMSG="[INFO]"

  if [ ! -z "$2" ]; then
    case "$2" in
      0)  STATUS="$INFO"
        STATUSMSG="[INFO]"
        ;;
      1)  STATUS="$SUCCESS"
        STATUSMSG="[OK]"
        ;;
      2)  STATUS="$WARNING"
        STATUSMSG="[WARNING]"
        ;;
      3)  STATUS="$DANGER"
        STATUSMSG="[FAIL]"
        ;;
      *)  STATUS="$INFO"
        STATUSMSG="[INFO]"
        ;;
    esac
  fi

  if [ ! -z "$3" ]; then
    STATUSMSG="$3"
  fi

  BEHAVIOUR=0
  if [ ! -z "$3" ]; then
    BEHAVIOUR="$3"
  fi

  if [ "$BEHAVIOUR" == 0 ] || [ "$BEHAVIOUR" == 1 ] || [ "$BEHAVIOUR" > 2 ]; then
    tput sc
    printf '%s%*s%s' $STATUS $col "$STATUSMSG" $normal
    tput rc
    printf "$1\n";
  fi

  if [ "$BEHAVIOUR" == 1 ] || [ "$BEHAVIOUR" == 2 ]; then
    echo logging
  fi
}


tellLoader() {
  local _pid
  local _delay
  local _spinstr
  local _inline

  _pid=$!
  _delay=0.1
  _spinstr="|/-\\"
  _inline=${1:-}

  setterm -cursor off
  ! helpers__empty "$_inline" && ua_move_cursor_up

  while kill -0 $_pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    helpers__empty "$_inline" && printf "\r${_spinstr:$i:1}" || ua_move_cursor_forward "$_inline"; echo -n "${_spinstr:$i:1}"; printf "\r"
    sleep $_delay
  done
    
  setterm -cursor on
  helpers__empty "$_inline" && printf "\r"

  return 0
}


tellClearFormatting() {
  tellMessage "$normal"
}
