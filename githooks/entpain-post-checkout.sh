#!/usr/bin/env bash

set -e

DEBUG=false
ROOTDIR=$(pwd)
ENTPAINDIR=${ROOTDIR}/tmp/entpain

# echo "post-checkout hook in ${ROOTDIR}"

PREVHEAD=$1
NEWHEAD=$2
CHECKOUTTYPE=$3

[[ $CHECKOUTTYPE == 1 ]] && CHECKOUTTYPE='branch' || CHECKOUTTYPE='file'

function entpainpack() {
  BRANCH=$1

  echo "entpain:pack $BRANCH"

  mkdir -p $ENTPAINDIR

  # make a list of files which are on gitignore
  git clean -n d -X ent/ | sed 's/Would remove //g' > ${ENTPAINDIR}/$BRANCH.files
  # create an archive of all those files, so we can switch back to it later
  tar czf ${ENTPAINDIR}/$BRANCH.tar.gz -T ${ENTPAINDIR}/$BRANCH.files
}

function entpainunpack() {
  BRANCH=$1

  # can only unpack if there's an archive
  if [[ -f ${ENTPAINDIR}/${BRANCH}.tar.gz ]]; then
    echo "entpain:unpack $BRANCH"

    # delete any git ignored files
    git clean -n d -X ent/
    # unpack from our archive
    tar xzf ${ENTPAINDIR}/${BRANCH}.tar.gz
  fi
}

if [[ $CHECKOUTTYPE == "branch" ]]; then
  PREVBRANCH=$(git name-rev --name-only $PREVHEAD || echo "")
  NEWBRANCH=$(git name-rev --name-only $NEWHEAD || echo "")

  if [[ "$PREVBRANCH" != "$NEWBRANCH" ]]; then
    [[ "${DEBUG}" == "true" ]] && \
      echo "entpain: ${PREVHEAD} (${PREVBRANCH}) -> ${NEWHEAD} (${NEWBRANCH})"

    # if we know which branch we're switch away from then we can create an archive for it
    if [[ "$PREVBRANCH" != "" && ! "$PREVBRANCH" =~ remotes\/.+ && ! "$PREVBRANCH" =~ ~[0-9]+$ ]]; then
      entpainpack "$PREVBRANCH"
    fi
    # if we know which branch we're switch towards than we can try to unpack its archive
    if [[ "$NEWBRANCH" != "" && ! "$NEWBRANCH" =~ remotes\/.+ && ! "$NEWBRANCH" =~ ~[0-9]+$  ]]; then
      entpainpack "$NEWBRANCH"
    fi
  fi
fi
