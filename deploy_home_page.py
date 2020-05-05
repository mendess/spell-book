#!/usr/bin/env python3

from os import chdir, environ, listdir
from os.path import isfile, join as pjoin

if 'SPELLS' not in environ:
    print('Spell dir not found')

if 'WALLPAPERS' not in environ:
    print('Wallpapers shell var not found')

chdir(environ['SPELLS'])

WALLS = environ['WALLPAPERS']
HOME = environ['HOME']

with open('runes/home.html', 'r') as i:
    with open(f'{HOME}/.cache/home.html', 'w') as o:
        for line in i:
            o.write(line)
            if 'const files =' in line:
                o.write(
                    ','.join(
                    [f"'{WALLS}/{f}'" for f in listdir(WALLS) if isfile(pjoin(WALLS, f))])
                )


