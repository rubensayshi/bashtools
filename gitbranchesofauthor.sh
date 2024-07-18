#!/bin/bash

FILTER_AUTHOR=$1

for BRANCH in `git branch -a | grep -v '*' | grep -v -E '^\*? *master$'`; do
	LC_AUTHOR=$(git log -1 --format='%an' $BRANCH)

	if [[ "$LC_AUTHOR" =~ "$FILTER_AUTHOR" ]]; then
		echo $BRANCH
	fi
done
