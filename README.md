# Spell Book
 A collection of scripts and dotfiles I like to keep handy.


## [Spells](./spells/): Scritps to be run by hand or through a keybind.

 - [add_rune](./spells/add_rune.spell) - Add a new [rune](runes-static-configuration-files) to the dotfiles, supports some customization options
 - [allgst](./spells/allgst.spell) - Performs `git status` on every folder in the `cwd`.
 - [battery_check](./spells/battery_check.spell) - Checks battery life and suspends if it's too low.
 - [bt-connect](./spells/bt-connect.spell)
 - [bulkrename](./spells/bulkrename.spell) - Bulk rename every file in the current directory using your default editor (Editor defined by $EDITOR or $VISUAL)
 - [changeMeWallCicle](./spells/changeMeWallCicle.spell) - Runs `changeMeWall` every 5 minutes
 - [changeMeWall](./spells/changeMeWall.spell) - Changes the wallpaper to a random one in the `$WALLPAPERS` folder. (requires `feh`).  Thanks [matilde](https://github.com/matildeopbravo) for the idea and help finding the more contrasting colors for dmenu
 - [change-zone](./spells/change-zone.spell)
 - [clean_ws_names](./spells/clean_ws_names.spell) - I sometimes rename my workspaces, this resets the name when the ws is empty. Supports bspwm and herbstluftwm
 - [daemons](./spells/daemons.spell) - Enable/disable my custom daemons
 - [dell-toggle-dock](./spells/dell-toggle-dock.spell)
 - [del_rss_feed](./spells/del_rss_feed.spell) - Script to be used by newsboat to delete the selected rss feed
 - [die_now](./spells/die_now.spell) - Auto shutdown that sets slowly dims the light, slowly lowers the song volume, and turns of the monitor(s)
 - [discord_voice](./spells/discord_voice.spell) - Change discord voice channel with dmenu
 - [ex](./spells/ex.spell) - Extract anything
 - [glavad](./spells/glavad.spell) - Open glava in the background, suports multiple screens_ish_
 - [hooks](./spells/hooks.spell)
 - [k](./spells/k.spell) - Configure my keymap, I'm too lazy to configure X and udev
 - [launch-cocktracice](./spells/launch-cocktracice.spell)
 - [lock](./spells/lock.spell)
 - [make-magic-wall](./spells/make-magic-wall.spell) - make a small wallpaper big by surrouding with a solid color. Inspired by: https://github.com/chrisJuresh/paperWiz
 - [mtg-wallpapers](./spells/mtg-wallpapers.spell) - Downloads the last 6 wallpapers uploaded to https://magic.wizards.com/en/articles/media/wallpapers.
 - [new-cards](./spells/new-cards.spell)
 - [new-rust-version](./spells/new-rust-version.spell)
 - [picker](./spells/picker.spell)
 - [playClipboard](./spells/playClipboard.spell) - Plays whatever is in the clipboard with xdg-open
 - [print](./spells/print.spell)
 - [projects](./spells/projects.spell) - Open dmenu, show me my projects, open a terminal in the selected one
 - [refresh_firefox](./spells/refresh_firefox.spell) - Refreshes firefox
 - [share](./spells/share.spell)
 - [ssh-menu](./spells/ssh-menu.spell) - A menu to quickly open ssh connections
 - [syncspellbook](./spells/syncspellbook.spell) - Tries to synchronise with changes to the remote repository. Also runs [learnSpells](./learnSpells.sh) and [castRunes](./castRunes.sh)
 - [termFromHere](./spells/termFromHere.spell) - Opens a terminal in the same `cwd` as the focused `X` program.
 - [todo](./spells/todo.spell) - Write/remove a task to do later.  Select an existing entry to remove it from the file, or type a new entry to add it.
 - [wfreetube](./spells/wfreetube.spell)
 - [wmgr](./spells/wmgr.crs)
 - [work-to-home](./spells/work-to-home.spell)
 - [xls_to_csv](./spells/xls_to_csv.spell) - Python script that converts a xls file to a csv

## [Cantrips](./cantrips/): Cantrips are scripts lauched from dmenu using the [menu](./cantrips/menu.sh).

 - [displayselect](./cantrips/displayselect.sh) - Configure multi monitors
 - [draw](./cantrips/draw.sh) - draw terminals
 - [emoji](./cantrips/emoji.sh) - Give dmenu list of all unicode characters to copy. Shows the selected character in dunst if running.
 - [free-nitro](./cantrips/free-nitro.sh) - I don't feel like paying discord, so I just store emoji gifs and quickly copy them to the clipboard to paste in chat. 😎
 - [game](./cantrips/game.sh) - Launch steam games from /comfy/ dmenu/fzf/tofi
 - [mconlinelist](./cantrips/mconlinelist.sh) - Send a notification with the list of online players in a minecraft server
 - [menu](./cantrips/menu.sh) - The menu used to find and launch the cantrips
 - [quickbrowser](./cantrips/quickbrowser.sh) - Launches vimb with one of the [bookmarks](./library/bookmarks)
 - [rename-ws](./cantrips/rename-ws.sh) - Dynamic [i3|bspwm|herbstluftwm] workspace renamer
 - [trayer](./cantrips/trayer.sh) - trayer launcher
 - [youtube](./cantrips/youtube.sh) - Launches the music player controled using [m](./spells/m.spell)

## [Runes](./runes/): Static configuration files


## [Scrolls](./scrolls/): Instalation scripts *Mostly untested*

 - [autologin](./scrolls/autologin.sh) - Setup auto login with or without password
 - [basicWF](./scrolls/basicWF.sh) - Sets up my basic workflow, install packages, configures some other packages.
 - [calendar](./scrolls/calendar.sh) - Configure khal using vdirsyncer
 - [dmenu](./scrolls/dmenu.sh) - Install my custom build of dmenu
 - [fix-dns-home](./scrolls/fix-dns-home.sh) - Fix my home dns resolution, basically sets the primary dns provider to the gateway and sets the secondary dns provider to 1.1.1.1 (cloudflare)
 - [fix-ssh-permissions](./scrolls/fix-ssh-permissions.sh)
 - [gestures](./scrolls/gestures.sh) - Enable gestures to switch workspace
 - [lutris](./scrolls/lutris.sh) - Install lutris and all the dependencies needed for battle net, assuming nvidia
 - [packages](./scrolls/packages.sh) - List of important packages
 - [spotify-adblock](./scrolls/spotify-adblock.sh) - Install a hacky addblock for spotify
 - [theme](./scrolls/theme.sh) - Setup the artim-dark theme
 - [thinkpad](./scrolls/thinkpad.sh)
