#!/bin/bash

find . -name "*.jpg" -exec mogrify -resize 50%  "{}" \;
