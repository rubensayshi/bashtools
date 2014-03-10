#!/bin/bash

HOSTS="web2 web3 celery1 varnish1 varnish2"
SUFFIX=".staging-cloud"

CMDS=$1 # "ls /var/www/jaws/app/jaws/texts.py*"
GO=""

echo ""
echo "${1}"
echo ""

for HOST in $HOSTS; do
    HOST="${HOST}${SUFFIX}"
    echo "=== ${HOST} ==="
    echo $CMDS | ssh $HOST bash
    echo ""
    echo ""
    
    while [ -z $GO ]; do 
        echo "==== :: EXECUTE ON ALL SERVERS ? [y/n] :: ===="
        read -e PROMPT
        echo ""

        if [ "Y" == "$PROMPT" -o "y" == "$PROMPT" ]; then
            echo ""
            GO="GO"
        fi 
        if [ "N" == "$PROMPT" -o "n" == "$PROMPT" ]; then
            echo ""
            exit
        fi
    done
done
