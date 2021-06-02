# Bar
- bg: `#aa222222`
- geometry: `x22`
- separator: ` | `
- n_clickables: `32`
- font: `Misc Termsynu: size=12`
- underline_width: `2`
- name: `bar_of_the_lemons`
- colors:
  - black: `#181818`
  - red: `#F07178`
  - green: `#a1b56c`
  - yellow: `#e3b97d`
  - blue: `#7cafc2`
  - magenta: `#ba8baf`
  - cyan: `#86c1b9`
  - white: `#d8d8d8`


## Workspaces
- persistent: `~/.config/lemonbar/workspaces`
- raw: `true`
- align: `left`
- multi_monitor: `true`

## Github notifications
- command: `~/.config/lemonbar/github_notifs.py`
- interval: `300`
- align: `left`
- left-click: `firefox "$(base64 -d <<<aHR0cHM6Ly9naXRodWIuY29tL25vdGlmaWNhdGlvbnM/cXVlcnk9aXMlM0F1bnJlYWQK)"`
- middle-click: `firefox "$(base64 -d <<<aHR0cHM6Ly9naXRodWIuY29tL25vdGlmaWNhdGlvbnM/cXVlcnk9aXMlM0F1bnJlYWQK)"`
- right-click: `firefox "$(base64 -d <<<aHR0cHM6Ly9naXRodWIuY29tL25vdGlmaWNhdGlvbnM/cXVlcnk9aXMlM0F1bnJlYWQK)"`
- fg: `red`
- underline: `red`
- signal: `true`

## Repo statuses
- command: `check_repos`
- interval: `300`
- align: `left`

## Uptime
- command: `echo "$(uptime -p)"`
- interval: `1800`
- align: `left`
- layer: `1`

## Room Temperature
- command: `echo "$(echo "$(ssh goblinww grep -oE '[0-9]{5}' /sys/bus/w1/devices/28-00000bc20d86/w1_slave 2>/dev/null) / 1000" | bc 2>/dev/null)°C"`
- interval: `60`
- align: `left`

## Package
- command: `[ ! -f ~/.package.sh ] || bash ~/.package.sh`
- interval: `3600`
- align: `left`
- left-click: `bash ~/.package.sh click`

## Music
- native: `m`
- alignment: `middle`
- left-click: `m prev-file`
- middle-click: `m pause`
- right-click: `m next-file`
- scroll-up: `m vu`
- scroll-down: `m vd`
- underline: `yellow`
- signal: `1`


## Spotify
- command: `pgrep spotify >/dev/null && python3 ~/.config/lemonbar/spotify_status.py -p ">,||" || :`
- underline: `green`
- left-click: `m prev-file`
- middle-click: `m pause`
- right-click: `m next-file`
- interval: `30`
- alignment: `middle`
- signal: `true`
- layer: `0`

## Spotify
- command: `python3 ~/.config/lemonbar/spotify_status.py -p ">,||" -s`
- underline: `green`
- left-click: `m prev-file`
- middle-click: `m pause`
- right-click: `m next-file`
- interval: `1`
- alignment: `middle`
- signal: `true`
- layer: `1`

## Brightness
- command: `~/.config/lemonbar/brightness`
- alignment: `right`
- signal: `true`
- interval: `1`
- layer: `1`

## Disk
- command: `~/.config/lemonbar/disk`
- alignment: `right`
- signal: `true`
- layer: `1`
- underline: `magenta`

## Iface
- command: `~/.config/lemonbar/iface`
- alignment: `right`
- un: `green`
- signal: `true`
- layer: `1`

## Wifi
- command: `~/.config/lemonbar/wifi | head -1`
- align: `right`
- un: `green`
- signal: `true`
- interval: `1`
- layer: `1`

## Load Average
- cmd: `~/.config/lemonbar/load_average`
- align: `right`
- signal: `true`
- interval: `1`
- layer: `1`
- underline: `magenta`

## Dnd
- cmd: `[ -e /tmp/.dnd ] && echo "dnd" || :`
- un: `red`
- fg: `red`
- align: `right`
- signal: `true`

## Batery
- cmd: `~/.config/lemonbar/battery`
- align: `right`
- interval: `10`

## Date command long
- command: `date`
- interval: `1`
- alignment: `right`
- signal: `true`
- underline: `cyan`
- layer: `1`

## Date command short
- command: `date +"%d/%m %H:%M"`
- interval: `10`
- alignment: `right`
- signal: `true`
- underline: `cyan`
- layer: `0`

