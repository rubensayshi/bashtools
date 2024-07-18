#!/bin/bash

KIND=kafkatopic
NAME=deliverorder-out
RELEASE_NAME=kafka-topics
NAMESPACE=aurora

kubectl annotate -n $NAMESPACE $KIND $NAME meta.helm.sh/release-name=$RELEASE_NAME
kubectl annotate -n $NAMESPACE $KIND $NAME meta.helm.sh/release-namespace=$NAMESPACE
kubectl label -n $NAMESPACE $KIND $NAME app.kubernetes.io/managed-by=Helm
