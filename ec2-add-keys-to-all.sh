#!/bin/bash

echo "fetching hosts..."
HOSTS=$(aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | {dns: .PublicDnsName, state: .State.Name, name: .Tags[] | select(.Key == "Name") | .Value} | select(.state == "running") | .dns')
echo $HOSTS

echo "provide key through stdin"

INPUT=$(cat -)

if [[ "${INPUT}" = "" ]]; then
    exit
fi

echo $INPUT

GO=""
while [ -z $GO ]; do 
    echo "==== :: ADD TO ALL SERVERS ? [y/n] :: ===="
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

for HOST in $HOSTS; do
    echo $HOST
    echo $INPUT | ssh $HOST 'cat >> .ssh/authorized_keys'
done

