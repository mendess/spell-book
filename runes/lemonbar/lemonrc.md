# Bar
- bg: `#222222aa`
- height: `22`
- separator: ` | `
%% switch on hostname
%% 3QWP3T3 {
- font: `Hack: size=18`
- font: `Noto Sans Mono CJK JP: size=15`
%% }
%% default {
- font: `Misc Termsynu: size=12`
- font: `Noto Sans Mono CJK JP: size=7`
%% }
%% end
- underline_width: `2`
- name: `bar_of_the_lemons`
- foreground: `#FFFFFF`
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
%% switch on hostname
%% 3QWP3T3 {
- persistent: `~/.config/lemonbar/workspaces`
%% }
%% default {
- native: `hyprland`
%% }
%% end
- raw: `true`
- align: `left`
- multi_monitor: `true`

## Github notifications
- command: `~/.config/lemonbar/github_notifs.py`
- interval: `150`
- align: `left`
- left-click: `$BROWSER 'https://github.com/notifications?query=is%3Aunread'`
- middle-click: `$BROWSER 'https://github.com/notifications?query=is%3Aunread'`
- right-click: `$BROWSER 'https://github.com/notifications?query=is%3Aunread'`
- fg: `red`
- underline: `red`
- signal: `true`

## Gitlab notifications
- command: `~/.config/lemonbar/gitlab_notifs.py`
- interval: `150`
- align: `left`
- left-click: `$BROWSER 'https://gitlab.cfdata.org/dashboard/todos'`
- middle-click: `$BROWSER 'https://gitlab.cfdata.org/dashboard/todos'`
- right-click: `$BROWSER 'https://gitlab.cfdata.org/dashboard/todos'`
- fg: `red`
- underline: `red`
- signal: `true`

## Uptime
- command: `echo "$(uptime -p)"`
- interval: `1800`
- align: `left`
- layer: `1`

## Room Temperature
- command: `ssh goblinww grep -oE '[0-9]{5}' /sys/bus/w1/devices/28-00000bc20d86/w1_slave 2>/dev/null | sed 's|$|/1000|' | bc 2>/dev/null | cut -d. -f1 | sed 's/$/°C/'`
- interval: `60`
- align: `left`

## CF Stock
- command: `bash ~/.config/lemonbar/cf-stock.sh`
- interval: `3600`
- align: `left`
- raw: `true`
- left-click: `bash ~/.config/lemonbar/cf-stock.sh click`

## Spell-Book status
- command: `n=$(git -C $SPELLS status --short | grep -v '^??' -c) && printf "book stat %s" $n`
- interval: `900`
- align: `left`
- fg: `yellow`

## Package
- command: `bash ~/.package.sh`
- pre_condition: `file-exists .package.sh`
- interval: `15`
- align: `left`
- left-click: `bash ~/.package.sh click`
- raw: `true`
- signal: `true`

## PowerMode
- persistent: `~/.local/bin/platform_profile low balanced performance`
- raw: `true`
- align: `left`

## Rust Version
- command: `new-rust-version | sed 's/^/new rust version: /'`
- interval: `3600`
- align: `left`
- left-click: `xdg-open https://blog.rust-lang.org`

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
- raw: `true`

## Bt
- command: `~/.config/lemonbar/bt-devices`
- underline: `blue`
- interval: `10`
- alignment: `right`

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
- cmd: `printf "dnd"`
- pre_condition: `file-exists /tmp/.dnd`
- un: `red`
- fg: `red`
- align: `right`
- signal: `true`

## Ram
- cmd: `free -h | sed -n 2p  | awk '{print $3 "/" $2}'`
- interval: `10`
- un: `yellow`
- fg: `white`
- layer: `1`
- align: `right`

## Recording
- cmd: `~/.config/lemonbar/recording-time.sh`
- pre_condition: `file-exists /tmp/mendess/ffmpeg_screenshot_pid`
- interval: `1`
- un: `red`
- align: `right`

## Batery
- cmd: `~/.config/lemonbar/battery`
- align: `right`
- interval: `10`
- raw: `true`

## Clock
- native: `clock`
- alignment: `right`
- underline: `cyan`
