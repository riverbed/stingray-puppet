#!/bin/bash

STM_PATH="$1"
TIP_GROUP="$2"
TIP_MACHINES="$3"
MACHINES=$STM_PATH/zxtm/conf/zxtms/*
FILE=$STM_PATH/zxtm/conf/flipper/$TIP_GROUP
TMP_FILE="$STM_PATH/zxtm/conf/flipper/.tmp_$TIP_GROUP"
ERB_PORTION="$STM_PATH/zxtm/conf/flipper/.$TIP_GROUP"
FILE_REGEX=".*/(.*)"
REPLICATE_CONFIG=$STM_PATH/zxtm/bin/replicate-config

if [$TIP_MACHINES == ""]; then
    cp "$ERB_PORTION" "$TMP_FILE"
    echo -n "machines" >> "$TMP_FILE"
    for machine in $MACHINES
    do
        if [[ $machine =~ $FILE_REGEX ]]; then
            act_machine=${BASH_REMATCH[1]}
            echo -n " $act_machine" >> "$TMP_FILE"
        fi
    done
    echo "" >> "$TMP_FILE"

    if ! cmp -s "$TMP_FILE" "$FILE"; then
        # files are different
        cp "$TMP_FILE" "$FILE"
        $REPLICATE_CONFIG --timeout=20
    fi
    rm "$TMP_FILE"
else
    if ! cmp -s "$ERB_PORTION" "$FILE"; then
        cp "$ERB_PORTION" "$FILE"
        $REPLICATE_CONFIG --timeout=20
    fi
fi
