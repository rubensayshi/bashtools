#!/bin/bash

VERSION=$1
ROOT=/work/bitcoin-bin
DATADIR=~/.bitcoin
DATAROOT=/mnt/ssd2/bitcoin-data

if [[ ! -d "${ROOT}/${VERSION}" ]]; then
	echo "Version ${VERSION} doesn't exist"
	exit 1
fi

for BINARY in "bitcoind" "bitcoin-cli" "bitcoin-tx"; do 
	echo "/usr/local/bin/bitcoin/${BINARY}"
	sudo rm /usr/local/bin/${BINARY}
	sudo ln -s ${ROOT}/${VERSION}/${BINARY} /usr/local/bin/${BINARY}
done

rm ${DATADIR}
ln -s ${DATAROOT}/.bitcoin-${VERSION} ${DATADIR}

