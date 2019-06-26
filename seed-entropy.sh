#!/bin/bash

DEVICE=/dev/cu.usbmodem14414401
OUT=$1
CNT=$2
if [[ ! -r $DEVICE ]]; then
	echo "device not found"
	exit 1
fi

dd if=$DEVICE ibs=1 count=$CNT obs=1024 | pv -pterb -s $CNT | dd of=$OUT
