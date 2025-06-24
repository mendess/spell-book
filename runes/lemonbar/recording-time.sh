#!/bin/bash

pidfile="/tmp/$LOGNAME/ffmpeg_screenshot_pid"

# Get current time and file modification time in seconds since epoch
NOW=$(date +%s)
FILE_MTIME=$(stat -c %Y "$pidfile")  # Use %Y for epoch time

# Calculate age in seconds
AGE_SECONDS=$((NOW - FILE_MTIME))

# Convert to HH:MM:SS
HH=$((AGE_SECONDS / 3600))
MM=$(( (AGE_SECONDS % 3600) / 60 ))
SS=$((AGE_SECONDS % 60))

printf "recording: "
# Print result
[[ "$HH" -gt 0 ]] && printf "%02d:" "$HH"
[[ "$MM" -gt 0 ]] && printf "%02d:" "$MM"
printf "%02d" "$SS"
:
