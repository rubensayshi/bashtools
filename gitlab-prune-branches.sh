#!/bin/bash

set -e

PROJECT_ID=68

GOGO="${1:-false}"

# we need to rerun the whole loop if we deleted some branches because we might be jumping over some of them
MORE="true"
while [[ "$MORE" == "true" ]]; do
	MORE="false"

	for i in $(seq 1 20); do
		echo "page $i ..."
		BRANCHES=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
	    					--url "https://gitlab.prvbl.com/api/v4/projects/${PROJECT_ID}/repository/branches?per_page=100&page=${i}" | jq -r '.[] | @base64')
		if [[ "$BRANCHES" == "" ]]; then
			break
		fi

		CLEANUP=

		for BRANCHB64 in $BRANCHES; do
			BRANCHDATA=$(echo "$BRANCHB64" | base64 -d)
			BRANCH=$(echo "${BRANCHDATA}" | jq -r '.name')
			COMMITDATE=$(echo "${BRANCHDATA}" | jq -r '.commit.committed_date')
			DIFF=$((($(date +%s) - $(date -d ${COMMITDATE} +%s))/86400))

			if [[ $DIFF -lt 60 ]]; then
				continue
			fi

			if [[ "$BRANCH" =~ -ci-build$ ]] || [[ "$BRANCH" =~ -k8s-(test|playground|uat|sandbox|demo)$ ]] || [[ "$BRANCH" =~ -merged$ ]] || [[ "$BRANCH" =~ -rebased$ ]] || [[ "$BRANCH" =~ ^release/v1\.(9|10|11|12|13|14|15|16)\.x- ]]; then
				echo "[[$BRANCH]](${DIFF} days old) matches prune pattern ($GOGO)"
				if [[ "$GOGO" == "true" ]]; then
					MORE="true"
					curl -s --fail -X DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
	    					--url "https://gitlab.prvbl.com/api/v4/projects/${PROJECT_ID}/repository/branches/$(printf %s "${BRANCH}" | sed -e 's/^[[:space:]]*//' | jq -sRr @uri)" && echo 'deleted'
				fi
			elif ([[ "$BRANCH" =~ ^AURORA-[0-9]{3,4}$ ]] || [[ "$BRANCH" =~ ^AURORA-[0-9]{3,4}[\/-] ]] || [[ "$BRANCH" =~ ^(chore|fix|feat|feature|test|tests|backup)/ ]]) && [[ $DIFF -gt 365 ]]; then
				echo "[[$BRANCH]](${DIFF} days old) is old ($GOGO)"
				if [[ "$GOGO" == "true" ]]; then
					MORE="true"
					curl -s --fail -X DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
	    					--url "https://gitlab.prvbl.com/api/v4/projects/${PROJECT_ID}/repository/branches/$(printf %s "${BRANCH}" | sed -e 's/^[[:space:]]*//' | jq -sRr @uri)" && echo 'deleted'
				fi
			elif ([[ ! "$BRANCH" =~ ^(backup|archive)/ ]]) && [[ $DIFF -gt 700 ]]; then
				echo "[[$BRANCH]](${DIFF} days old) is very old ($GOGO)"
				if [[ "$GOGO" == "true" ]]; then
					MORE="true"
					curl -s --fail -X DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
	    					--url "https://gitlab.prvbl.com/api/v4/projects/${PROJECT_ID}/repository/branches/$(printf %s "${BRANCH}" | sed -e 's/^[[:space:]]*//' | jq -sRr @uri)" && echo 'deleted'
				fi
			fi
		done
	done
done
