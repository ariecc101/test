#!/bin/bash
if [ -z "$1" ]; then
    echo "No arguments supplied"
    exit 1
fi

HOME=$1
NAME=$(basename $HOME)


if [ ! -d "$HOME" ]; then
    echo "Directory $HOME doesnt exist"
    exit 1
fi

journalctl -fu $NAME