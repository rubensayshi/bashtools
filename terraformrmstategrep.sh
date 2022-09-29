#!/bin/bash

RESOURCES=$(terraform state list | grep -E $1 |  tr '\n' ' ')
echo "$RESOURCES"

if [[ "$RESOURCES" != "" ]]; then
	terraform state rm $RESOURCES
fi

