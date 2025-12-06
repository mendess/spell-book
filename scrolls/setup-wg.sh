#!/bin/bash

cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/pendrellvale.conf
[Resolve]
DNS=10.0.0.1
FallbackDNS=1.1.1.1
Domains=home ~.
ResolveUnicastSingleLabel=yes
EOF

cat <<EOF | sudo tee /usr/lib/systemd/system/wg-pre-dns-fix.service
[Unit]
Description=WireGuard Endpoint Pre-DNS Fix
After=network-online.target systemd-resolved.service
Before=wg-quick@wg0.service

[Service]
Type=oneshot
# This command routes the ONLY the mendess.xyz query to the public DNS on wlp0s20f3
ExecStart=/usr/bin/resolvectl domain wlp0s20f3 mendess.xyz
ExecStop=/usr/bin/resolvectl domain wlp0s20f3 -mendess.xyz
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo sctl daemon-reload
sudo sctl enable wg-pre-dns-fix.service
sudo sctl start wg-pre-dns-fix.service
sudo sctl restart systemd-resolved
