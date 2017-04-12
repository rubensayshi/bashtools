#!/bin/bash

EC2NEWGROUP="$1"

if [[ "${EC2NEWGROUP}" = "" ]]; then
    echo "missing NEWGROUP"
    exit 1
fi

echo "fetching instance IDs..."
INSTANCEIDS=$(aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | {id: .InstanceId, state: .State.Name, name: .Tags[] | select(.Key == "Name") | .Value} | select(.state == "running") | .id')
echo $INSTANCEIDS

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

for INSTANCEID in $INSTANCEIDS; do
    ec2-add-sg.sh $INSTANCEID $EC2NEWGROUP
done

