#!/bin/bash

LIMIT=${LIMIT:-20}

OLD_IFS=${IFS}
IFS=$'\n'
OPTIONS=( `git -c color.ui=always log -${LIMIT} --format='%C(yellow)%h%Creset %<(100,trunc)%s' --grep fixup --invert-grep | sed 's/ *$//g'` )
IFS=${OLD_IFS}

# echo ${#OPTIONS[@]}
# for element in "${OPTIONS[@]}"; do
#    echo "${element}"
# done

OPTIONS+=( "QUIT" )

select OPTION in "${OPTIONS[@]}"; do
	if [[ "$OPTION" == "QUIT" ]]; then
		exit 1
	fi
	if [[ "$OPTION" == "" ]]; then
		echo "unknown option..."
		exit 1
	fi

	# matching a ? with sed is a pita, so we use .
	COMMIT=$(echo $OPTION | awk '{print $1}' | sed 's/.\[[0-9;]*m//g')

	echo "> git commit --fixup $COMMIT $*"
	git commit --fixup $COMMIT $*
	exit 0
done
