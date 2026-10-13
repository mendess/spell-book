#!/bin/bash

set -eou pipefail

con=$(nmcli --terse con show | grep ethernet | cut -d: -f1)

if [ $# -lt 1 ]; then
    echo "USAGE: $0 [LSB of the ip]"
    exit 1
fi

address=192.168.42.$1/24
gateway=192.168.42.1
dns=192.168.42.2
static-ip() {
    method=$(nmcli --terse con show "$con" | grep 'ipv4.method')
    case "${1:-''}" in
        apply)
            if [[ "$method" = ipv4.method:manual ]]; then
                echo "static ip already setup"
                return
            fi
            echo "setting up static ip"
            echo address="$address"
            echo gateway=$gateway
            echo dns=$dns
            sudo nmcli con mod "$con" \
                ipv4.address "$address" \
                ipv4.gateway "$gateway" \
                ipv4.dns "$dns" \
                ipv4.dns-search "lan" \
                ipv4.method "manual"
            sudo nmcli con down "$con"
            sudo nmcli con up "$con"
            ;;
        revert)
            if [[ "$method" = ipv4.method:auto ]]; then
                echo "dynamic ip already setup"
                return
            fi
            echo "enabling dhcp"
            sudo nmcli con mod "$con" \
                ipv4.address "" \
                ipv4.gateway "" \
                ipv4.dns "" \
                ipv4.dns-search "" \
                ipv4.method "auto"
            sudo nmcli con down "$con"
            sudo nmcli con up "$con"
            ;;
        *)
            echo "usage $0 apply|revert"
            return 1
            ;;
    esac
}

static-ip "$@"
