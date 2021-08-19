#!/usr/bin/env bash

set -e

DEBUG=false
ROOTDIR=$(pwd)
ENTPAINDIR=${ROOTDIR}/tmp/entpain
ENTPAINPACKDIRS=${ENTPAINPACKDIRS:-ent/}
ENTPAINPACKDIRS=$(echo "$ENTPAINPACKDIRS" | tr "," "\n")
# echo "post-checkout hook in ${ROOTDIR}"

PREVHEAD=$1
NEWHEAD=$2
CHECKOUTTYPE=$3

[[ $CHECKOUTTYPE == 1 ]] && CHECKOUTTYPE='branch' || CHECKOUTTYPE='file'

function entpainpack() {
  BRANCH=$1
  BRANCHSLUG=$(echo "$1" | sed 's/\//__/g')

  echo "entpain:pack $BRANCH"

  mkdir -p $ENTPAINDIR

  # reset list of files to pack
  echo "" > ${ENTPAINDIR}/$BRANCHSLUG.files

  # for each dir to pack add to the list of files
  for ENTPAINPACKDIR in $ENTPAINPACKDIRS; do
    # make a list of files which are on gitignore
    git clean -n -d -X $ENTPAINPACKDIR | sed 's/Would remove //g' >> ${ENTPAINDIR}/$BRANCHSLUG.files
  done

  # create an archive of all those files, so we can switch back to it later
  tar czf ${ENTPAINDIR}/$BRANCHSLUG.tar.gz -T ${ENTPAINDIR}/$BRANCHSLUG.files
}

function entpainunpack() {
  BRANCH=$1
  BRANCHSLUG=$(echo "$1" | sed 's/\//__/g')

  # can only unpack if there's an archive
  if [[ -f ${ENTPAINDIR}/${BRANCHSLUG}.tar.gz ]]; then
    echo "entpain:unpack $BRANCH"

    # for each dir to unpack delete any git ignored files
    for ENTPAINPACKDIR in $ENTPAINPACKDIRS; do
      git clean -q -f -d -X $ENTPAINPACKDIR
    done
    # unpack from our archive
    tar xzf ${ENTPAINDIR}/${BRANCHSLUG}.tar.gz
  fi
}

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
    # if we know which branch we're switch away from then we can create an archive for it
    if [[ "$PREVBRANCH" != "" && ! "$PREVBRANCH" =~ remotes\/.+ && ! "$PREVBRANCH" =~ ~[0-9]+$ && "$PREVBRANCH" != "undefined" ]]; then
      entpainpack "$PREVBRANCH"
    fi
    # if we know which branch we're switch towards than we can try to unpack its archive
    if [[ "$NEWBRANCH" != "" && ! "$NEWBRANCH" =~ remotes\/.+ && ! "$NEWBRANCH" =~ ~[0-9]+$ && "$NEWBRANCH" != "undefined" ]]; then
      entpainunpack "$NEWBRANCH"
    fi
  fi
fi

