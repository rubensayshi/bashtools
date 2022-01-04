#!/bin/bash

# curl --header "PRIVATE-TOKEN: glpat-ZVV8wbarp2sudS_-Byye" "https://gitlab.com/api/v4/groups/privacyblockchain/projects?per_page=100&all_available=true&include_subgroups=true" | jq

REPOS=$(curl --header "PRIVATE-TOKEN: glpat-ZVV8wbarp2sudS_-Byye" "https://gitlab.com/api/v4/groups/privacyblockchain/projects?per_page=100&all_available=true&include_subgroups=true" | jq -r '.[] | (.ssh_url_to_repo + " " + .path_with_namespace) | @base64')

for REPO in $REPOS; do
	REPO=$(echo $REPO | base64 -d)
	echo $REPO
	git clone $REPO
done
