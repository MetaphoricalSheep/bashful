# output formatter
if [[ -z "$__MONKEYDIR__" ]]
then
    echo -e "\e[31m""ERROR: \e[39m\e[49m You cannot source this file directly. Source monkey-wrench.sh. \e[39m\n"
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
    if [ -z "$1"  ]; then
        return 1
    fi

    msg="$1"

    echo -e $(php "$__MONKEYDIR__"/modules/submodules/formatter.php "$msg")
}

tellFancyTitle() {
    require_parameter_count "$FUNCNAME" "$LINENO" 1 "$#"

    local _title="  $1              "; shift
    local _title_space=""
    local _subtitle="  TITLE:  "
    local _subtitle_space="        "
    local _format="question"

    if ! empty "$1"
    then
        local _subtitle=" $1 "; shift;
        _subtitle_space=""
        for i in `seq 1 ${#_subtitle}`; do
            _subtitle_space="$_subtitle_space"" "
        done
    fi

    for i in `seq 1 ${#_title}`; do
        _title_space="$_title_space"" "
    done

    if ! empty "$1"
    then
        _format="$1"
    fi

    local _final="\n<$_format>$_subtitle_space</><bg=white;fg=black>$_title_space</>\n"
    _final="$_final<$_format>$_subtitle</><bg=white;fg=black>$_title</>\n"
    _final="$_final<$_format>$_subtitle_space</><bg=white;fg=black>$_title_space</>\n"

    format_message "$_final"
}

tellTitle() {
    if [ -z "$1" ]; then
        tellError "Message (arg1) is required for function \`$FUNCNAME\` on line $LINENO!"
        printf "   Line: "
        caller
        exit $?
    fi

    MSG="$1"
    SPACE="  "

    for i in `seq 1 ${#MSG}`; do
        SPACE="$SPACE"" "
    done

    SPACE="$SPACE""  "

    if empty "$2"
    then
        MSG="\n<question>$SPACE\n  $MSG  \n$SPACE</>\n"
    else
        MSG="\n<$2>$SPACE\n  $MSG  \n$SPACE</>\n"
    fi

    format_message "$MSG"
}

tellMessage() {
    if [ -z "$1" ]; then
        tellError "Message (arg1) is required for function \`$FUNCNAME\` on line $LINENO!"
        printf "   Line: "
        caller
        exit $?
    fi

    format_message "$1"
}

# $1=message    #required
# $2=color all  #default=no
tellError() {
    if [ -z "$1" ]; then
        tellError "Message (arg1) is required for function \`$FUNCNAME\` on line $LINENO"
        printf "   Line: "
        caller
        exit $?
    fi

    local MSG=$1
    local SPACE=""

    for i in `seq 1 ${#MSG}`; do
        SPACE="$SPACE"" "
    done

    SPACE="$SPACE""    "

    MSG="\n<bg=c_196>          </><bg=white>$SPACE</>\n"
    MSG="$MSG<fg=white;bg=c_196>  ERROR:  </><fg=c_238;bg=white>  $1  </>\n"
    MSG="$MSG<bg=c_196>          </><bg=white>$SPACE</>\n"
    format_message "$MSG"
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
    local pid=$!

    if [[ -z "$2" ]]; then
        local delay=0.1
    else
        local delay="$2"
    fi

    if [[ -z "$3" ]]; then
        local spinstr='|/-\'
    else
        local spinstr="$3"
    fi

    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf "\r${spinstr:$i:1}"
        sleep $delay
    done

    echo ""
}

tellClearFormatting() {
    tellMessage "$normal"
}
