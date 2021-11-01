#!/bin/bash

sha256sum <(find $1 -type f -exec sha256sum \; | sort)
