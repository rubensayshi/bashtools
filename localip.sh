#!/bin/bash

ifconfig $(route -n | awk '/UG[ \t]/{print $8}' | head -1) | grep inet | head -1 | awk '{print $2}'
