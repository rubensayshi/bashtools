#!/bin/bash

grep -h testcase target/surefire-reports/TEST-*.xml | \
	awk -F '"' '{print $4 "#" $2 "() - " $6 "ms" }' | \
	sort -rn -k 3
