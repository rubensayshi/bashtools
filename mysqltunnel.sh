#!/bin/bash

HOST=$1
PORT=$2

ssh -f $HOST -L $PORT:localhost:3306 -N
