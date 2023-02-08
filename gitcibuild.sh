#!/bin/bash

git push -f origin `git branch --show-current`:`git branch --show-current`-ci-build # ci-build

