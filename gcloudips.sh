#!/bin/bash

echo "iptables-gcloud:"

for i in `seq 1 7`; do
	dig txt _cloud-netblocks${i}.googleusercontent.com  +short
done | tr " " "\n" | grep ip4  | cut -f 2 -d : | sort -n | sed 's/^/  - /g'
