#!/bin/bash

docker-compose logs --tail=1 -f client \
| grep --line-buffered -E -o "(Compiling|Compiled)" \
| xargs -I {} -L1 macnotify.sh "client" "{}"
