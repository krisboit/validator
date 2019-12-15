#!/bin/bash
echo "Starting validator $3 ..."

SCRIPT="./blockchains/$1/$2/stop.sh"
if [ -f $SCRIPT ]; then 
    sh $SCRIPT
else 
    echo "ERROR: Stop script was not found. ($SCRIPT)"
fi