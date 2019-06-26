#!/bin/bash

>&2 clear
>&2 echo -n "watch ssh..."

PIDS=
while [[ true ]]; do
	NEWPIDS=`pgrep ssh`

	if [[ "$NEWPIDS" != "" ]]; then
		>&2 echo -n "!"
		if [[ "$PIDS" != "$NEWPIDS" ]]; then
			PIDS=$NEWPIDS
			>&2 clear
			>&2 echo "watch ssh..."

			for PID in $PIDS; do
				echo "----- `date` -----"
				pstree -p $PID
				echo "-----------------------------------------"
			done

			>&2 echo ""
		fi
	else		
		>&2 echo -n "."
	fi

	sleep 1
done