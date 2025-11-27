#!/bin/bash

sudo lsof -i +c 0 -P | grep LISTEN

