#!/bin/bash

git push -f origin `git branch --show-current`:`git branch --show-current`-k8s-test # k8s-test

