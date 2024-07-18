#!/bin/bash

if [[ "$1" == "" ]]; then
	echo "need name to push"
	exit 1
fi

git push -f origin `git branch --show-current`:$1
