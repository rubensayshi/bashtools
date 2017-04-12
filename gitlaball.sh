#!/bin/bash

REPOS=$(curl --header "PRIVATE-TOKEN: eH3kF27jQ2cS462CMgDu" "https://gitlab.bitmain.com/api/v3/projects?per_page=100" | jq -r '.[].ssh_url_to_repo')

for REPO in $REPOS; do
	echo $REPO
	git clone $REPO
done
