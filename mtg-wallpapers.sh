#!/bin/bash
curl -s https://magic.wizards.com/en/articles/media/wallpapers | grep '1920x1080' | cut -d'=' -f2 | cut -d'"' -f2 | xargs wget
