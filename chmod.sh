#!/bin/bash

chmod 0775 .
find . -type f -exec chmod 664 {} +
find . -type d -exec chmod 775 {} +

