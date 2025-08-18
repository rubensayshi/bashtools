#!/bin/bash

if [[ $1 == "" ]]; then
	echo "need release name"; exit 1
fi

git push -f origin `git branch --show-current`:release/$1

