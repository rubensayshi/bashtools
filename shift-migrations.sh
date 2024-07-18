#!/bin/bash

FROM=$1
TO=$2
GO=${3:-false}

if [[ "$FROM" == "" || "$TO" == "" ]]; then
	exit 1
fi

DIFF=$(($TO - $FROM))

echo "shifting $FROM -> $TO (+$DIFF)"

for migration in `ls *.sql`; do
	rawnum=$(echo "$migration" | sed 's/^\([0-9]*\)_.*/\1/g')
	num=$(echo "$rawnum" | sed 's/^0*//')

	if [[ $num -ge $FROM ]]; then
		newnum=$(($num + $DIFF))
		newname=$(echo "$migration" | sed "s/$num/$newnum/g")
		echo "$migration ($num -> $newnum) -> $newname"

		if [[ "$GO" == "true" ]]; then
			mv $migration $newname
		fi
	fi
done
