#!/bin/bash

BIN="$1"
WHICH=$(which $BIN)
if [[ "${WHICH}" == "" || ! -f "${WHICH}" ]]; then
	echo "failed to find [$BIN]"
	exit 1
fi

echo "found [${BIN}]: ${WHICH}"

rm $WHICH && echo "deleted"

WHICH=$(which $BIN)
if [[ "${WHICH}" != "" ]]; then
	echo "there's still a [$BIN]: ${WHICH}"
fi
