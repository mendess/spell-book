#!/bin/bash
sleep 30
while true;
do
    cd $(dirname "$0")
    [ -e ./changeMeWall.sh ] && . ./changeMeWall.sh
    [ -e ./changeMeWall ] && . ./changeMeWall
    sleep 5m
done
