#!/bin/bash
# Install my custom build of dmenu

set -e

cd /tmp
rm -rf dmenu
git clone https://github.com/mendess/dmenu
(cd dmenu && make arch_install)
rm -rf dmenu
