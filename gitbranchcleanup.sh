#!/bin/bash

# delete any branches which have been merged into master (and aren't current branch or master)
git branch --merged master | grep -v '*' | grep -v -E '^\*? *master$' | xargs -n 1 git branch -d

for BRANCH in `git branch | grep -v '*' | grep -v -E '^\*? *master$'`; do
	DELETE=""
	while [ -z $DELETE ]; do 
	    echo "==== :: $BRANCH delete [y/N] :: ===="
		git log -1 --format='%s  (%an / %cd)' $BRANCH
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
	fi
	
	echo
done
