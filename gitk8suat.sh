#!/bin/bash

git push -f origin `git branch --show-current`:`git branch --show-current`-k8s-uat # k8s-uat

