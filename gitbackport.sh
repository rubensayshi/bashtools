#!/bin/bash

set -e

FROM=$1
TO=$2
FROM_UPTO=${3:-200}
TO_UPTO=$(( $FROM_UPTO * 5 ))

while IFS= read -r line; do
	COMMIT="$( cut -d ';' -f 1 <<< "$line" )"
	MSG="$( cut -d ';' -f 2- <<< "$line" )"

	# skip any merge commits
	if [[ "$MSG" =~ ^Merge\ branch\ \' ]]; then
		continue
	fi

	# check if the commit message appears in the target
	if git log --pretty=format:'%h - %s' --abbrev-commit $TO | head -$TO_UPTO | grep "$MSG" > /dev/null; then
		# echo "GOT: $COMMIT - $MSG"
		continue
	fi

	echo "MISSING: $COMMIT - $MSG"


done < <(git log --pretty=format:'%h;%s' --abbrev-commit $FROM | head -$FROM_UPTO)
