# Spell Book
 A collection of scripts and dotfiles I like to keep handy.


## [Spells](./spells/): Scritps to be run by hand or through a keybind.

 - [add_gift](./spells/add_gift.spell)
 - [add_rune](./spells/add_rune.spell)
 - [allgst](./spells/allgst.spell) - Performs `git status` on every folder in the `cwd`.
 - [battery_check](./spells/battery_check.spell) - Checks battery life and suspends if it's too low.
 - [bookmark](./spells/bookmark.spell) - Adds a bookmark to the [bookmarks](./runes/bookmarks)
 - [bulkrename](./spells/bulkrename.spell)
 - [changeMeWallCicle](./spells/changeMeWallCicle.spell) - Runs `changeMeWall` every 5 minutes
 - [changeMeWall](./spells/changeMeWall.spell) - Changes the wallpaper to a random one in the `$WALLPAPERS` folder. (requires `feh`).  Thanks [matilde](https://github.com/matildeopbravo) for the idea and help finding the more contrasting colors for dmenu
 - [daemons](./spells/daemons.spell)
 - [del_rss_feed](./spells/del_rss_feed.spell)
 - [die_now](./spells/die_now.spell)
 - [ex](./spells/ex.spell)
 - [f](./spells/f.spell) - A fzf file finder I stole from [matilde](https://github.com/matildeopbravo)
 - [glavad](./spells/glavad.spell)
 - [mtg-wallpapers](./spells/mtg-wallpapers.spell) - Downloads the last 6 wallpapers uploaded to https://magic.wizards.com/en/articles/media/wallpapers.
 - [naoseioquefaco](./spells/naoseioquefaco.spell) - A gift from the love of my life [matilde](https://github.com/matildeopbravo)
 - [picker](./spells/picker.spell)
 - [playClipboard](./spells/playClipboard.spell) - Plays whatever is in the clipboard with xdg-open
 - [reload_newsboat](./spells/reload_newsboat.spell)
 - [run_disown](./spells/run_disown.spell)
 - [snapit](./spells/snapit.spell)
 - [subscribe](./spells/subscribe.spell)
 - [syncmusic](./spells/syncmusic.spell)
 - [syncspellbook](./spells/syncspellbook.spell) - Tries to synchronise with changes to the remote repository. Also runs [learnSpells](./learnSpells.sh) and [castRunes](./castRunes.sh)
 - [termFromHere](./spells/termFromHere.spell) - Opens a terminal in the same `cwd` as the focused `X` program.
 - [todo](./spells/todo.spell) - Write/remove a task to do later.  Select an existing entry to remove it from the file, or type a new entry to add it.
 - [update_calendar](./spells/update_calendar.spell)
 - [update_discord_dnd](./spells/update_discord_dnd.spell)
 - [update_rust_analyzer](./spells/update_rust_analyzer.spell)
 - [wmgr](./spells/wmgr.spell)
 - [xls_to_csv](./spells/xls_to_csv.spell)

## [Cantrips](./cantrips/): Cantrips are scripts lauched from dmenu using the
[menu](./cantrips/menu.sh).

 - [bspwm-rename-ws](./cantrips/bspwm-rename-ws.sh) - Renames the current workspace
 - [displayselect](./cantrips/displayselect.sh)
 - [draw](./cantrips/draw.sh) - draw terminals
 - [emoji](./cantrips/emoji.sh) - Give dmenu list of all unicode characters to copy. Shows the selected character in dunst if running.
 - [game](./cantrips/game.sh) - Launch steam games from /comfy/ dmenu
 - [i3-rename-ws](./cantrips/i3-rename-ws.sh)
 - [mconlinelist](./cantrips/mconlinelist.sh)
 - [menu](./cantrips/menu.sh)
 - [quickbrowser](./cantrips/quickbrowser.sh) - Launches vimb with one of the [bookmarks](./library/bookmarks)
 - [schedule](./cantrips/schedule.sh)
 - [youtube](./cantrips/youtube.sh) - Launches the music player controled using [m](./spells/m.spell)

## [Runes](./runes/): Static configuration files


## [Scrolls](./scrolls/): Instalation scripts *Mostly untested*

 - [autologin](./scrolls/autologin.sh)
 - [basicWF](./scrolls/basicWF.sh)
 - [calendar](./scrolls/calendar.sh)
 - [dmenu](./scrolls/dmenu.sh)
 - [gestures](./scrolls/gestures.sh)
 - [lutris](./scrolls/lutris.sh)
 - [nfs_walls](./scrolls/nfs_walls.sh)
 - [packages](./scrolls/packages.sh)
 - [spotify-adblock](./scrolls/spotify-adblock.sh)
 - [theme](./scrolls/theme.sh)
 - [thinkpad](./scrolls/thinkpad.sh)
