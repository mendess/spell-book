#!/bin/bash
# Launches the music player controled using [m](./spells/m.spell)

RUST_LOG=debug SESSION_KIND=gui m play-interactive
