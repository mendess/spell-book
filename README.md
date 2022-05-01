# Spell Book
 A collection of scripts and dotfiles I like to keep handy.


## [Spells](./spells/): Scritps to be run by hand or through a keybind.

 - [add_gift](./spells/add_gift.spell)
 - [add_rune](./spells/add_rune.spell) - Add a new [rune](runes-static-configuration-files) to the dotfiles, supports some customization options
 - [allgst](./spells/allgst.spell) - Performs `git status` on every folder in the `cwd`.
 - [battery_check](./spells/battery_check.spell) - Checks battery life and suspends if it's too low.
 - [bookmark](./spells/bookmark.spell) - Adds a bookmark to the [bookmarks](./runes/bookmarks)
 - [bulkrename](./spells/bulkrename.spell) - Bulk rename every file in the current directory using your default editor (Editor defined by $EDITOR or $VISUAL)
 - [changeMeWallCicle](./spells/changeMeWallCicle.spell) - Runs `changeMeWall` every 5 minutes
 - [changeMeWall](./spells/changeMeWall.spell) - Changes the wallpaper to a random one in the `$WALLPAPERS` folder. (requires `feh`).  Thanks [matilde](https://github.com/matildeopbravo) for the idea and help finding the more contrasting colors for dmenu
 - [check_repos](./spells/check_repos.spell) - Script for my bar, shows repository status as little icons
 - [clean_ws_names](./spells/clean_ws_names.spell) - I sometimes rename my workspaces, this resets the name when the ws is empty. Supports bspwm and herbstluftwm
 - [daemons](./spells/daemons.spell) - Enable/disable my custom daemons
 - [del_rss_feed](./spells/del_rss_feed.spell) - Script to be used by newsboat to delete the selected rss feed
 - [die_now](./spells/die_now.spell) - Auto shutdown that sets slowly dims the light, slowly lowers the song volume, and turns of the monitor(s)
 - [discord_voice](./spells/discord_voice.spell) - Change discord voice channel with dmenu
 - [ex](./spells/ex.spell) - Extract anything
 - [glavad](./spells/glavad.spell) - Open glava in the background, suports multiple screens_ish_
 - [k](./spells/k.spell) - Configure my keymap, I'm too lazy to configure X and udev
 - [make-magic-wall](./spells/make-magic-wall.spell)
 - [mtg-wallpapers](./spells/mtg-wallpapers.spell) - Downloads the last 6 wallpapers uploaded to https://magic.wizards.com/en/articles/media/wallpapers.
 - [picker](./spells/picker.spell) - Wrapper around dmenu and fzf to unify their options, it's not very good
 - [playClipboard](./spells/playClipboard.spell) - Plays whatever is in the clipboard with xdg-open
 - [projects](./spells/projects.spell) - Open dmenu, show me my projects, open a terminal in the selected one
 - [refresh_firefox](./spells/refresh_firefox.spell) - Refreshes firefox
 - [snapit](./spells/snapit.spell) - A printscreen script, supports crop to clipboard, crop to file, fullscreen print and floating print
 - [ssh-menu](./spells/ssh-menu.spell) - A menu to quickly open ssh connections
 - [subscribe](./spells/subscribe.spell) - Subscribe to a youtube channel as an rss feed
 - [syncmusic](./spells/syncmusic.spell) - A termux only script that predownloads all music from $PLAYLIST
 - [syncspellbook](./spells/syncspellbook.spell) - Tries to synchronise with changes to the remote repository. Also runs [learnSpells](./learnSpells.sh) and [castRunes](./castRunes.sh)
 - [termFromHere](./spells/termFromHere.spell) - Opens a terminal in the same `cwd` as the focused `X` program.
 - [todo](./spells/todo.spell) - Write/remove a task to do later.  Select an existing entry to remove it from the file, or type a new entry to add it.
 - [update_discord_dnd](./spells/update_discord_dnd.spell) - Using a "copied as curl" request to change discord status to or front dnd, update the remote to use the new request
 - [update_rust_analyzer](./spells/update_rust_analyzer.spell) - Update rust_analyzer from the latest github release
 - [wmgr](./spells/wmgr.spell) - Wallpaper manager
 - [xls_to_csv](./spells/xls_to_csv.spell) - Python script that converts a xls file to a csv

## [Cantrips](./cantrips/): Cantrips are scripts lauched from dmenu using the [menu](./cantrips/menu.sh).

 - [displayselect](./cantrips/displayselect.sh) - Configure multi monitors
 - [draw](./cantrips/draw.sh) - draw terminals
 - [emoji](./cantrips/emoji.sh) - Give dmenu list of all unicode characters to copy. Shows the selected character in dunst if running.
 - [empty_monitor](./cantrips/empty_monitor.sh)
 - [free-nitro](./cantrips/free-nitro.sh)
 - [game](./cantrips/game.sh) - Launch steam games from /comfy/ dmenu
 - [mconlinelist](./cantrips/mconlinelist.sh) - Send a notification with the list of online players in a minecraft server
 - [menu](./cantrips/menu.sh) - The menu used to find and launch the cantrips
 - [quickbrowser](./cantrips/quickbrowser.sh) - Launches vimb with one of the [bookmarks](./library/bookmarks)
 - [rename-ws](./cantrips/rename-ws.sh) - Dynamic [i3|bspwm] workspace renamer
 - [trayer](./cantrips/trayer.sh) - trayer launcher
 - [youtube](./cantrips/youtube.sh) - Launches the music player controled using [m](./spells/m.spell)

## [Runes](./runes/): Static configuration files


## [Scrolls](./scrolls/): Instalation scripts *Mostly untested*

 - [autologin](./scrolls/autologin.sh) - Setup auto login with or without password
 - [basicWF](./scrolls/basicWF.sh)
 - [calendar](./scrolls/calendar.sh) - Configure khal using vdirsyncer
 - [dmenu](./scrolls/dmenu.sh) - Install my custom build of dmenu
 - [fix-dns-home](./scrolls/fix-dns-home.sh)
 - [gestures](./scrolls/gestures.sh) - Enable gestures to switch workspace
 - [lutris](./scrolls/lutris.sh) - Install lutris and all the dependencies needed for battle net, assuming nvidia
 - [nfs_walls](./scrolls/nfs_walls.sh) - Create a network mounted filesystem for my wallpapers
 - [packages](./scrolls/packages.sh) - List of important packages
 - [spotify-adblock](./scrolls/spotify-adblock.sh) - Install a hacky addblock for spotify
 - [theme](./scrolls/theme.sh) - Setup the artim-dark theme
 - [thinkpad](./scrolls/thinkpad.sh)
