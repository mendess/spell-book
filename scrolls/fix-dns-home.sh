#!/bin/bash
# Fix my home dns resolution, basically sets the primary dns provider to the
# gateway and sets the secondary dns provider to 1.1.1.1 (cloudflare)

con="${1:-$(nmcli -t --fields NAME connection show --active | head -1)}"
read -rp "Change dns for network $con [Y/n]? "
[[ "${REPLY,,}" = n ]] && exit
[[ "$gateway" ]] ||
    gateway=$(nmcli -t --fields IP4.GATEWAY connection show "$con" | cut -d: -f2)
echo "Using gateway: $gateway"
old_dns=$(nmcli -t --fields ipv4.dns connection show "$con" | cut -d: -f2 | tr ',' ' ')
new_dns="$gateway 1.1.1.1"
echo "Changing dns: $old_dns -> $new_dns"
nmcli con mod "$con" ipv4.dns "$new_dns"
nmcli con mod "$con" ipv4.ignore-auto-dns yes
echo "Restarting connection"
nmcli con down "$con"
nmcli con up "$con"
echo "Done!"
