#!/bin/bash

# 0 -> throttling disabled = fast
# 1 -> throttling enabled = slow
if [[ "$1" != "1" ]] && [[ "$1" != "0" ]]; then
	echo "valid arg [01]"
	exit 1
fi 

sudo sysctl debug.lowpri\_throttle_enabled=$1
