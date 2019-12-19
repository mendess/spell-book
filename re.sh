#!/bin/sh

ffmpeg \
-f pulse -ac 2 -ar 48000 -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
-f pulse -ac 2 -ar 44100 -i alsa_input.pci-0000_00_1f.3.analog-stereo \
-filter_complex amix=inputs=2 \
-video_size 1920x1080 \
-framerate 30 \
-f x11grab -i :0.0+0,0 \
"output-$(date +"%d_%m_%Y_%H_%M").mp4"
