#!/bin/sh

cwd="$(pwd)"
cd /tmp
git clone https://github.com/abba23/spotify-adblock-linux.git
cd spotify-adblock-linux
make
sudo make install
cd "$cwd"
cat <<EOF > ~/.local/bin/spotify
#!/bin/bash
LD_PRELOAD="/usr/local/lib/spotify-adblock.so" /usr/bin/spotify
EOF
chmod +x ~/.local/bin/spotify
