#!/bin/bash
cd $(dirname "$(realpath $0)")

sh $(ls -l | tail -n +2 | awk '{print $9}' | grep -v 'menu' | dmenu -i -p "Pick a menu:" -l 5)
