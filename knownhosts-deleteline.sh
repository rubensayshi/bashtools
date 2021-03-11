#!/bin/bash

if [[ -f ~/.ssh/known_hosts.backup ]]; then
	rm ~/.ssh/known_hosts.backup
fi

sed -i.bak -e "${1}d" ~/.ssh/known_hosts
