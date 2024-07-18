#!/bin/bash

if [[ "$1" == "" ]]; then
	echo "need suffix to push"
	exit 1
fi

git push -f origin `git branch --show-current`:`git branch --show-current`$1
