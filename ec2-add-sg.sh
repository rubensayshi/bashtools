#!/bin/bash

ID="$1"
EC2NEWGROUP="$2"

if [[ "${ID}" = "" ]]; then
    echo "missing ID"
    exit 1
fi

if [[ "${EC2NEWGROUP}" = "" ]]; then
    echo "missing NEWGROUP"
    exit 1
fi

echo $ID

EC2GROUPS=$(aws ec2 describe-instance-attribute --instance-id ${ID} --attribute groupSet | jq -r '.Groups[].GroupId' | tr '\n' ' ')


if [[ $EC2GROUPS == *"${EC2NEWGROUP}"* ]]; then
    echo "Already there"
else
    aws ec2 modify-instance-attribute --instance-id ${ID} --groups $EC2GROUPS $EC2NEWGROUP
    echo "Added"
fi
