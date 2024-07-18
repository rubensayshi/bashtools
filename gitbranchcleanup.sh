#!/bin/bash

# delete any branches which have been merged into master (and aren't current branch or master)
git branch --merged master | grep -v '*' | grep -v -E '^\*? *master$' | xargs -n 1 git branch -d

for BRANCH in `git branch | grep -v '*' | grep -v -E '^\*? *master$'`; do
	LC_AUTHOR=$(git log -1 --format='%an' $BRANCH)
	DIFF=$((($(date +%s) - $(date -d @$(git log -1 --format='%ct' $BRANCH) +%s))/86400))

	DELETE=""

	if [[ "$BRANCH" =~ ^AURORA-[0-9]+\/ ]] && ! [[ "$LC_AUTHOR" =~ Ruben ]] && [[ $DIFF -gt 30 ]]; then
		echo "old feature branch (${DIFF}d) from someone else ($LC_AUTHOR), deleting ..."
		DELETE=yes
	fi
	if [[ "$BRANCH" =~ ^AURORA-[0-9]+\/ ]] && [[ "$LC_AUTHOR" =~ Ruben ]] && [[ $DIFF -gt 90 ]]; then
		echo "very old feature branch (${DIFF}d) from you ($LC_AUTHOR), deleting ..."
		DELETE=yes
	fi

	if [ "$DELETE" = "yes" ]; then
		git branch -D $BRANCH
	fi
done

for BRANCH in `git branch | grep -v '*' | grep -v -E '^\*? *master$'`; do
	LATESTCOMMIT=$(git log -1 --format='%s  (%an / %cd)' $BRANCH)
	LC_AUTHOR=$(git log -1 --format='%an' $BRANCH)
	DIFF=$((($(date +%s) - $(date -d @$(git log -1 --format='%ct' $BRANCH) +%s))/86400))

	if [[ $DIFF -lt 90 ]]; then
		continue
	fi

	DELETE=""
	while [ -z $DELETE ]; do 
	    echo "==== :: $BRANCH		${LC_AUTHOR} // ${DIFF}d		delete [y/N] :: ===="
	    # echo "$LATESTCOMMIT"
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
