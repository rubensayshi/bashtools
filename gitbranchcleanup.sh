#!/bin/bash

git branch --merged master | grep -v '*' | grep -v -E '^(\* )master$' | xargs -n 1 git branch -d

for BRANCH in `git branch | grep -v '*' | grep -v -E '^(\* )master$'`; do
	echo $BRANCH

	DELETE=""
	while [ -z $DELETE ]; do 
	    echo "==== :: $BRANCH delete [y/N] :: ===="
	    read -e PROMPT

	    if [ "Y" == "$PROMPT" -o "y" == "$PROMPT" ]; then
	        DELETE="yes"
	    fi 
	    if [ "N" == "$PROMPT" -o "n" == "$PROMPT" -o "" == "$PROMPT" ]; then
	        DELETE="no"
	    fi
	done

	if [ "$DELETE" = "yes" ]; then
		git branch -D $BRANCH
		echo
	fi
done