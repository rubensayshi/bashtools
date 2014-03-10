#!/bin/bash

URL=$1
LOCALURL=$URL
HOSTSPRESET=$2

# $URL is required
[ -z "${URL}" ] && echo "PLEASE SPECIFY URL" && exit 1

if [ -z "${HOSTSPRESET}" ]; then
    HOSTS="varnish3.upcoming.nl varnish4.upcoming.nl 0.static.upcoming.nl 1.static.upcoming.nl localhost"
elif [ "${HOSTSPRESET}" = "varnish" ]; then
    HOSTS="varnish3.upcoming.nl varnish4.upcoming.nl"
elif [ "${HOSTSPRESET}" = "static" ]; then
    HOSTS="0.static.upcoming.nl 1.static.upcoming.nl"
else
    HOSTS=$HOSTSPRESET
fi


for HOST in $HOSTS; do 
    LOCALURL=$(echo "${LOCALURL}" | sed "s/${HOST}/127.0.0.1/g")
done

echo ">>>>>>> ${LOCALURL}"

for HOST in $HOSTS; do 
    echo ">>>>>>> ${HOST}"
    curl --noproxy -v "${LOCALURL}" -H "Host: ${HOST}" -X "PURGE"
done


