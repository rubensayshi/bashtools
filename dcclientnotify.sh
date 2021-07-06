#!/bin/bash

docker-compose logs --tail=1 -f client \
| grep --line-buffered -E -o "(Compiling|Compiled)" \
| xargs -L1 -I {} notify-send "client" "{}"
