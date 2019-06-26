#!/bin/bash
set -ex

sudo mv /Library/Developer/CommandLineTools /Library/Developer/CommandLineTools.old || echo ""
xcode-select --install
sudo rm -rf /Library/Developer/CommandLineTools.old
