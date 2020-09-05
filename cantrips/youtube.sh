#!/bin/bash

m gui play-interactive
pgrep jukebox || jukebox --room tolaria jukebox
