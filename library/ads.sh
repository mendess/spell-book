#!/bin/bash

while read -r v;
do
    echo "$v" 1>&2
    link=$(echo "$v" | awk -F'\t' '{print $2}')
    echo "$v" | awk -F'\t' '{ line = $1"\t"$2"\t"; line = line "'"$(youtube-dl --get-duration "$link" | sed -E 's/(.*):(.+):(.+)/\1*3600+\2*60+\3/;s/(.+):(.+)/\1*60+\2/' | bc)"'\t"; for(i = 3; i <= NF; i++) { line = line  $i "\t" }; print line}' &
done < playlist
