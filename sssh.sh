#!/bin/bash

data=$(cat ~/Dropbox/backups/ssh.data)
[ -z "$data" ] && exit 1

# pick connetion
machines=$(echo "$data" | grep -v "$(uname -n)" | cut -d';' -f2)
echo "$machines" | nl
echo -n "pick (empty to cancel)> "
read -r pick
[ -z "$pick" ] && exit
machine="$(echo "$data" | sed -n "${pick}p")"

# pick mode
if [ "$(echo "$machine" | cut -d';' -f2-3)" = ";" ]
then
    echo no data on "$(echo "$machine" | cut -d';' -f2)"
elif [ -z "$(echo "$machine" | cut -d';' -f2)" ]
then
    mode="r"
elif [ -z "$(echo "$machine" | cut -d';' -f3)" ]
then
    mode="l"
else
    echo -n "local or remote? (l/r)> "
    read -r mode
fi

[ -z "$mode" ] && exit

# ssh into connection
if [ "$mode" = "l" ]
then
    ssh "$(echo "$machine" | cut -d';' -f1)"@"$(echo "$machine" | cut -d';' -f2)"
elif [ "$mode" = "r" ]
then
    ssh "$(echo "$machine" | cut -d';' -f1)"@"$(echo "$machine" | cut -d';' -f3)"
else
    echo invalid mode option: "$mode"
fi
