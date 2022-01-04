#!/usr/bin/env bash

#
# this is a git post-rewrite hook to cache auto generated files per branch 
#  and quickly switch between them without having to regenerate the files.
#
# it's complementary to the post-checkout hook and should be placed in `.git/hooks/post-rewrite` (note: without the `.sh`!).
# I personally just symlink it in there from wherever I placed the original ;)
#

set -e

DEBUG=false
ROOTDIR=$(pwd)
ENTPAINDIR=${ROOTDIR}/tmp/entpain
ENTPAINPACKDIRS=${ENTPAINPACKDIRS:-ent/,quickfix/dtcc/,}
ENTPAINPACKDIRS=$(echo "$ENTPAINPACKDIRS" | tr "," "\n")

function dbg() {
  echo "$*" | tee -a ${ROOTDIR}/tmp/entpain.log 1>&2
}

function entpainunpack() {
  BRANCH=$1
  BRANCHSLUG=$(echo "$1" | sed 's/\//__/g')

  # can only unpack if there's an archive
  if [[ -f ${ENTPAINDIR}/${BRANCHSLUG}.tar.gz ]]; then
    dbg "entpain:unpack $BRANCH"

    # for each dir to unpack delete any git ignored files
    for ENTPAINPACKDIR in $ENTPAINPACKDIRS; do
      if [[ -d $ENTPAINPACKDIR ]]; then
        git clean -q -f -d -X $ENTPAINPACKDIR
      fi
    done
    # unpack from our archive
    tar xzf ${ENTPAINDIR}/${BRANCHSLUG}.tar.gz
  fi
}


if [[ "$1" == "rebase" && "$2" == "" ]]; then
  HEAD=
  while read LINE
  do
    if [[ "$LINE" != "" ]]; then
      COMMITS=($LINE)
      HEAD=${COMMITS[1]}
    fi
  done < /dev/stdin
  
  if [[ "$HEAD" == "" ]]; then
  	exit 0
  fi

  BRANCH=$(git name-rev --exclude 'remotes/*' --exclude='tags/*' --name-only $HEAD || echo "")
  # master is special, there's often other branches with the same ref but we want to prioritize master ...
  MASTERSHA=$(git rev-parse master)
  if [[ "$VHEAD" == "$MASTERSHA" ]]; then
    BRANCH=master
  fi

  dbg "entpain:post-rewrite $HEAD = $BRANCH"

  # if we know which branch we're switch towards than we can try to unpack its archive
  if [[ "$BRANCH" != "" && ! "$BRANCH" =~ remotes\/.+ && ! "$BRANCH" =~ ~[0-9]+$ && "$BRANCH" != "undefined" ]]; then
    entpainunpack "$BRANCH"
  fi
fi
