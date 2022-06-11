#!/bin/bash

# start X server
echo "Starting X server"
nohup X :0 -config dummy.conf &

# run converter
echo "Converting files"
cd files
export DISPLAY=:0
python3 ../converter.py "$@"