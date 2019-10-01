# scripts
 A collection of scripts I like to keep handy

## Spells *(scripts)*

- [allgst](./spells/allgst.spell) Performs `git status` on every folder in the `cwd`.
- [bash_color](./spells/bash_color.spell) Display a certain RGB combo to the terminal and the
  corresponding escape sequence.
- [battery_check](./spells/battery_check.spell) Checks battery life and suspends if it's too
  low
    - *[battery_check_cicle](./spells/battery_check_cicle.spell) runs this every 10 seconds.*
- [bookmark](./spells/bookmark.spell) Adds a bookmark to the [bookmarks](./library/bookmarks)
- [castRunes](./castRunes.sh) Creates a sym-link for every rune in
  [runes](runes/). The location of the sym-link depends on the rune and is
  defined in the script.
- [changeMeWall](./spells/changeMeWall.spell) Changes the wallpaper to a random one in the
  `~/Pictures/Wallpapers` folder (requires `nitrogem`).
    - *[changeMeWallCicle](./spells/changeMeWallCicle.spell) runs this every 5 minutes.*
- [gitconfig](./spells/gitconfig.spell) Configures git with my credentials.
- [library](./spells/library.spell) Loads a bunch of helper variables.

- [mtg-wallpapers](./spells/mtg-wallpapers.spell) Downloads the last 6 wallpapers to show
  https://magic.wizards.com/en/articles/media/wallpapers.
- [playClipboard](./spells/playClipboard.spell) Plays whatever is in the clipboard on mpv.
- [scrot-rename](./spells/scrot-rename.spell) Used to rename screenshots. (see i3 config).
- [sssh](./spell/sssh.spell) Manages ssh connections.
- [syncspellbook](./spells/syncspellbook.spell) Tries to synchronise with changes to the
  remote repository. Also runs [updatespellbook](./updatespellbook.spell)
  and [castRunes](./castRunes.sh).
- [termFromHere](./spells/termFromHere.spell) Opens a terminal in the same `cwd` as the focused `X`
  program. (Meant to be used with `i3wm`)

## Cantrips
Cantrips are scripts lauched from dmenu using the [menu](./cantrips/menu.sh).
- [youtube](./cantrips/youtube.sh) Launches the music player controled using [m](./spells/m.spell)
- [quickbrowser](./cantrips/quickbrowser.sh) Launches surf with one of the [bookmarks](./library/bookmarks)
- [today](./cantrips/today.sh) Show's today's apointments
- [i3-rename-ws](./cantrips/i3-rename-ws.sh) Renames de current workspace

### Music Player
- [m](./spells/m.spell) Is the main entry point to control the music player. It also manages the
  [playlist](./library/playlist).

## Runes *(config files)*
Static configuration files: [runes/](./runes/)
