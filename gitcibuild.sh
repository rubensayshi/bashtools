#!/bin/bash

SUFFIX="$1"

SRC=`git branch --show-current`
DEST=`git branch --show-current`-ci-build
if [[ "$SUFFIX" != "" ]]; then
	DEST=`git branch --show-current`-$SUFFIX-ci-build
fi


git push -f origin $SRC:$DEST
