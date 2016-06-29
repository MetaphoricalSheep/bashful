#
# Inserts given DATA at specific line of file
# 
append_file() {
    DATA=""
    LINE=1
    TEMP=/tmp/$(date +%s)

    if empty "$1"
    then
        tellError "You must specify a file to append."

        exit 1
    fi

    FILE="$1"

    if ! empty "$2"
    then
        DATA="$2"
    fi

    if (! empty -z "$3") && (is_number "$3")
    then
        LINE="$3"
    fi

    head --lines=-"$LINE" "$FILE" > "$TEMP"
    echo "$DATA" >> "$TEMP"
    tail --lines="$LINE" "$FILE" >> "$TEMP"

    mv "$TEMP" "$FILE"
}
