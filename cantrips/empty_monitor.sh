#!/bin/bash

bspc -a 'placeholder'

bspc query -D -m focused | sed '$d' | {
    m="$(bspc query -M -m any.\!focused | head -1)"
    while read -r d; do
        bspc desktop "$d" --to-monitor "$m"
    done
}
