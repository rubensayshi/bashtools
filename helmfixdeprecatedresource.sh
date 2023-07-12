#!/bin/bash

set -e

verbose=
cleanup=yes
while getopts n:r:c:v: flag
do
    case "${flag}" in
    n) namespace=${OPTARG};;
	r) release=${OPTARG};;
	c) context=${OPTARG};;
    v) verbose=true;;
    esac
done

if [ -z ${context+x} ] || [ -z ${release+x} ] || [ -z ${namespace+x} ]; then echo "namespace, release and context must be defined"; exit 0; fi

echo "Change context to $context"
kubectl config use-context $context

echo "Get release object"
releaseObject=$(kubectl get secret -l owner=helm,status=deployed,name=$release --namespace $namespace | awk '{print $1}' | grep -v NAME)

echo "Export secret to $release.release.yaml"
kubectl get secret $releaseObject -n $namespace -o yaml > $release.release.yaml

echo "Create backup"
cp $release.release.yaml $release.release.bak

echo "Decode"
yq e '.data.release' $release.release.yaml | base64 -d | base64 -d | gzip -d > $release.release.data.decoded

if [[ $verbose != "" ]]; then
    cat $release.release.data.decoded | jq -r '.manifest'
fi

echo "Replace api"
sed -i -e 's/policy\/v1beta1/policy\/v1/' $release.release.data.decoded

if [[ $verbose != "" ]]; then
    cat $release.release.data.decoded | jq -r '.manifest'
fi

echo "Encode"
cat $release.release.data.decoded | gzip | base64 | base64 > $release.release.data.encoded

echo "Remove newlines"
tr -d "\n" < $release.release.data.encoded > $release.release.data.encoded.final
releaseData=$(cat $release.release.data.encoded.final)

echo "Replace data.release"
cp $release.release.yaml $release.final.release.yaml
yq e -i '.data.release = "'$releaseData'"' $release.final.release.yaml

echo "Applying to kubernetes"
kubectl apply -f $release.final.release.yaml -n $namespace

if [[ "$cleanup" == "yes" ]]; then
    rm $release.release.yaml
    rm $release.release.data.decoded
    rm $release.release.data.encoded
    rm $release.release.data.encoded.final
    rm $release.final.release.yaml
fi