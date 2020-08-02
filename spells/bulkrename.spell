#!/bin/sh

from="$(mktemp)"
to="$(mktemp)"

trap 'rm $from $to' 0 1 2 3 6 14 15

echo "# use # to skip renaming a file" > "$from"
find ./* -maxdepth 0 | sed 's|./||g' >> "$from"
cp "$from" "$to"
if [ "$EDITOR" ]; then
    ed="$EDITOR"
elif [ "$VISUAL" ]; then
    ed="$VISUAL"
else
    ed=vim
fi

"$ed" "$to"

python -c "from sys import argv
import subprocess

with open('$from', 'r') as f:
    f1 = [l.strip() for l in f]

with open('$to', 'r') as f:
    f2 = [l.strip() for l in f]

filt = lambda x: x[0] != x[1] and not x[1].startswith('#')

for l1, l2 in filter(filt, zip(f1, f2)):
    print(f\"mv -vi '{l1}' '{l2}'\")

c = input('Confirm [Y/n] ')

if c != 'n' and c != 'N':
    for l1, l2 in filter(filt, zip(f1, f2)):
        subprocess.run(['mv', '-vi', l1, l2])
"
