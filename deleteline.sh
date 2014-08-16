#!/bin/bash

FILE=$1
LINE=$2

sed -i "${LINE}d" $FILE
