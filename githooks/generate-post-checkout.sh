#!/usr/bin/env bash

set -e

DEBUG=false
ROOTDIR=$(pwd)

PREVHEAD=$1
NEWHEAD=$2
CHECKOUTTYPE=$3

echo "post-checkout hook in ${ROOTDIR} with args: $PREVHEAD $NEWHEAD $CHECKOUTTYPE"

if [[ $CHECKOUTTYPE == 1 ]]; then
	CHECKOUTTYPE='branch'
else
	CHECKOUTTYPE='file'
fi

if [[ $CHECKOUTTYPE == "branch" ]]; then
  PREVBRANCH=$(git name-rev --exclude 'remotes/*' --exclude='tags/*' --name-only $PREVHEAD || echo "")
  NEWBRANCH=$(git name-rev --exclude 'remotes/*' --exclude='tags/*' --name-only $NEWHEAD || echo "")

  # master is special, there's often other branches with the same ref but we want to prioritize master ...
  MASTERSHA=$(git rev-parse master)
  if [[ "$PREVHEAD" == "$MASTERSHA" ]]; then
    PREVBRANCH=master
  fi
  if [[ "$NEWHEAD" == "$MASTERSHA" ]]; then
    NEWBRANCH=master
  fi

  if [[ "$PREVBRANCH" != "$NEWBRANCH" ]]; then
    [[ "${DEBUG}" == "true" ]] && \
      echo "entpain: ${PREVHEAD} (${PREVBRANCH}) -> ${NEWHEAD} (${NEWBRANCH})"

      make -C $ROOTDIR generate
  fi
fi

