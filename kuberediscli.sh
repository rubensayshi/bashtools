#!/bin/bash

set -ef

HOSTPORT=$(kubectl -n aurora get secrets redis -o json | jq -r '.data.host' | base64 -d)
HOSTPORTARR=(${HOSTPORT//:/ })
HOST=${HOSTPORTARR[0]}
PORT=${HOSTPORTARR[1]}

echo "${HOST}::${PORT}" 1>&2
echo "you might have to hit SHIFT+R for the prompt to show up ..." 1>&2

kubectl run -n aurora redis-cli --restart=Never --rm -it --image redis -- redis-cli -h $HOST -p $PORT $*

