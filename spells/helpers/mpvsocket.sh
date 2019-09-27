#!/bin/sh

if [ -e /tmp ]
then
    export MPVSOCKET=/tmp/mpvsocket
else
    export MPVSOCKET=~/.mpvsocket
fi
