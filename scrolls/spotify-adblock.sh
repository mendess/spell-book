#!/bin/sh
# Install a hacky addblock for spotify

cwd="$(pwd)"
cd /tmp
git clone https://github.com/abba23/spotify-adblock-linux.git
cd spotify-adblock-linux || exit
grep wget README.md | sed 's/\$//g' | sh
grep 'tar.*wildcards' README.md | sed 's/\$//g' | sh
make
sudo make install
cd "$cwd" || exit
cat <<EOF > ~/.local/bin/spotify
#!/bin/bash
LD_PRELOAD="/usr/local/lib/spotify-adblock.so" /usr/bin/spotify
EOF
chmod +x ~/.local/bin/spotify
