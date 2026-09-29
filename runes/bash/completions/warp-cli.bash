#!/bin/bash

hash warp-cli &>/dev/null &&
    . <(warp-cli generate-completions bash)
