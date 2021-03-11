#!/bin/bash

jq -r '.[].jsonPayload | select(. != null) | .timestamp + " " + .level + ":" + .logger + ": " + .message + " " + .exception' < /dev/stdin
