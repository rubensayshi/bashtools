#!/bin/bash

# master API
kubectl cluster-info | grep 'Kubernetes control plane' | awk '/http/ {print $NF}'
GITLABADMINSECRET=$(kubectl -n kube-system get secret | grep gitlab-admin | awk '{print $1}')
# cert
kubectl -n kube-system get secret $GITLABADMINSECRET -o jsonpath="{['data']['ca\.crt']}" | base64 -d
# token
echo $(kubectl -n kube-system get secret $GITLABADMINSECRET -o jsonpath="{['data']['token']}" | base64 -d)
