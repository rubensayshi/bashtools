#!/bin/bash

kubectl logs -n $KUBECTL_NAMESPACE --tail=10000 -f --max-log-requests=20 -l "${@}"
