#!/bin/bash

sudo modprobe -r iwlwifi
sudo modprobe iwlwifi 11n_disable=1
