#!/bin/bash

set -e

CURRENT=$(xdotool getwindowfocus)
ZOOM=$(xdotool search --limit 1 --name "Zoom Meeting")
xdotool windowactivate --sync ${ZOOM}
xdotool key --clearmodifiers "alt+a"
xdotool windowactivate --sync ${CURRENT}
