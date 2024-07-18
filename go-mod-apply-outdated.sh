#!/bin/bash

IN=$1
FILTER=$2

cat $IN | go-mod-outdated -update -direct

if [[ "$FILTER" != "" ]]; then
    cat $IN | go-mod-outdated -update -direct | grep $FILTER
    IFS=$'\n' read -d '' -r -a PACKAGES < <(cat $IN | go-mod-outdated -update -direct | grep $FILTER | awk '{print $2, $4, $6}')
else
    IFS=$'\n' read -d '' -r -a PACKAGES < <(cat $IN | go-mod-outdated -update -direct | tail -n +4 | awk '{print $2, $4, $6}')
fi

echo ${#PACKAGES[@]}

for LINE in "${PACKAGES[@]}"; do
    if [[ "$LINE" == "" || "$LINE" == " " ]]; then
        continue
    fi

    PACKAGE=$(echo $LINE | awk '{print $1}')
    OLD=$(echo $LINE | awk '{print $2}')
    NEW=$(echo $LINE | awk '{print $3}')

    echo -n " == [$PACKAGE]  $OLD -> $NEW; upgrade [y/N]? "
    read -e PROMPT
    if [ "Y" == "$PROMPT" -o "y" == "$PROMPT" ]; then
        UPGRADE="yes"
    fi
    if [ "N" == "$PROMPT" -o "n" == "$PROMPT" -o "" == "$PROMPT" ]; then
        UPGRADE="no"
    fi
    if [[ "$UPGRADE" == "yes" ]]; then
        ESCAPED_PACKAGE=$(printf '%s\n' "$PACKAGE" | sed -e 's/[\/&]/\\&/g')
        sed -i '' "s/$ESCAPED_PACKAGE $OLD/$ESCAPED_PACKAGE $NEW/g" go.mod
    fi
done