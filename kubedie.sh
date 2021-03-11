#!/bin/bash

set -e

NS=$1
POD=$2

kubectl patch -n $NS pod $POD -p '{"metadata":{"finalizers": []}}'
kubectl delete -n $NS pod --force --grace-period=0 $POD


