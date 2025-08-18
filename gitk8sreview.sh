#!/bin/bash

git push -f origin `git branch --show-current`:`git branch --show-current`-k8s-review # k8s-review
