#!/bin/bash

if [ -z $BRANCHINITIALS ]; then
	echo "missing BRANCHINITIALS"
	exit 1
fi

NAME="$1"
while [ -z $NAME ]; do 
    echo "==== :: ENTER BRANCH NAME :: ===="
    read -e NAME
    echo ""
done

BRANCH="ft/master/`date +%Y-%m-%d`-${BRANCHINITIALS}-${NAME}"

echo $BRANCH

GO=""
while [ -z $GO ]; do 
    echo "==== :: CREATE? [Y/n] :: ===="
    read -e PROMPT
    echo ""

    if [ "Y" == "$PROMPT" -o "y" == "$PROMPT" -o "" == "$PROMPT" ]; then
        GO="GO"
    fi 
    if [ "N" == "$PROMPT" -o "n" == "$PROMPT" ]; then
        exit
    fi
done

git checkout -b $BRANCH ${@:2}
