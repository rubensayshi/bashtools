#!/bin/bash

LEN=${1:-32}

env LC_CTYPE=C tr -dc "A-Za-z0-9" < /dev/urandom | head -c $LEN | xargs

