#!/bin/bash

last=
while :; do
    current=$(cat /sys/firmware/acpi/platform_profile)
    if [ "$current" != "$last" ]; then
        echo "$current"
    fi
    last=$current
    sleep 30
done
