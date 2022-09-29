#!/bin/bash

cat $1  | grep -E -o 'const Schema = `(.*)`' | sed 's/const Schema = `\(.*\)`/\1/g' | jq
