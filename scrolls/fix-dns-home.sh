#!/bin/bash

con="${1:-ZON-2010-5Ghz}"
nmcli con mod "$con" ipv4.dns "192.168.1.1 1.1.1.1"
nmcli con mod "$con" ipv4.ignore-auto-dns yes
nmcli con down "$con"
nmcli con up "$con"
