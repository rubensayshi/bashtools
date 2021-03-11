#!/bin/bash

FILES=$(find . -name '*.go')
TOTAL="0"

for FILE in $FILES; do
    CNT=$(pcre2grep -M 'import \((\n|.)*?\)' $FILE | \
          pcregrep -v -M '^[ \t]*\n[ \t]*//' | \
          grep -E "^[ \t]*$" | \
          wc -l | \
          sed 's/ //g')

    if [[ "$CNT" -gt 1 ]]; then
        echo "${FILE} : ${CNT}"
    fi

    TOTAL=$((TOTAL + CNT))
done

echo "TOTAL: ${TOTAL}"
if [[ "${TOTAL}" -gt 0 ]]; then
    exit 1
fi
