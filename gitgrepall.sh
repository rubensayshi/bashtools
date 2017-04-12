#!/bin/bash

DIRS=$(ls)

for DIR in $DIRS; do 
	>&2 echo $DIR
	cd $DIR
	git --no-pager log -p -S$1
	cd ..
done
