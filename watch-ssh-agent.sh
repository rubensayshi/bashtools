#!/bin/bash

>&2 clear
>&2 echo -n "watch gpg-agent..."

say "watching gpg-agent"

LASTLINE=0
tail -f /var/log/gpg-agent.log | grep -E "-> PKSIGN" | xargs -n1 _watch-ssh-agent-exec.sh

while [[ true ]]; do
	NEWPIDS=`pgrep ssh`

	if [[ "$NEWPIDS" != "" ]]; then
		>&2 echo -n "!"
		if [[ "$PIDS" != "$NEWPIDS" ]]; then
			PIDS=$NEWPIDS
			>&2 clear
			>&2 echo "watch ssh..."
			WAITSTART="$(date -u +%s)"

			for PID in $PIDS; do
				echo "----- `date` -----"
				pstree -p $PID
				echo "-----------------------------------------"
				echo "----- `date` -----"
				ps aux | grep $PID
				echo "-----------------------------------------"
			done

			>&2 echo ""
		else
			NOW="$(date -u +%s)"
			WAITINGFOR="$(($NOW-$WAITSTART))"
			
			if (( WAITINGFOR == 5 )); then
			    say ssh
			fi
			
			>&2 echo -n "${WAITINGFOR}..."
		fi
	else		
		>&2 echo -n "."
	fi

	sleep 1
done