# scripts
 A collection of scripts I like to keep handy

## Spells *(scripts)*

- [allgst](./spells/allgst.sh) Performs `git status` on every folder in the `cwd`.
- [bash_color](./spells/bash_color.sh) Display a certain RGB combo to the terminal and the
  corresponding escape sequence.
- [castRunes](./spells/castRunes.sh) Creates a sym-link for every rune in
  [runes](runes/). The location of the sym-link depends on the rune and is
  defined in the script.
- [changeMeWall](./spells/changeMeWall.sh) Changes the wallpaper to a random one in the
  `~/Pictures/Wallpapers` folder (requires `nitrogem`).
    - *[changeMeWallCicle](changeMeWallCicle.sh) runs this every 5 minutes.*
- [gitconfig](./spells/gitconfig.sh) Configures git with my credentials.
- [learnSpells](./spells/learnSpells.sh) Creates a sym-link on `~/.local/bin` to every
  spell.
- [mtg-wallpapers](./spells/mtg-wallpapers.sh) Downloads the last 6 wallpapers to show
  https://magic.wizards.com/en/articles/media/wallpapers.
- [playClipboard](./spells/playClipboard.spell) Plays whatever is in the clipboard on mpv.
- [scrot-rename](./spells/scrot-rename.spell) Used to rename screenshots. (see i3 config).
- [sssh](./spell/sssh.sh) Manages ssh connections.
- [syncspellbook](./spells/syncspellbook.sh) Tries to synchronise with changes to the
  remote repository. Also runs [updatespellbook](updatespellbook.sh)
  and [castRunes](./spells/castRunes.sh).
- [termFromHere](./spells/termFromHere.sh) Opens a terminal in the same `cwd` as the focused `X`
  program. (Meant to be used with `i3wm`)

### Cantrips Helpers
- [back](./spells/back.spell), [frwd](./spells/frwd.spell), [vu](./spells/vu.spell), [vd](./spells/vd.spell), [next](./spells/next.spell), [prev](./spells/prev.spell), [pause](./spells/pause.spell) Serve as meia keys to control mpv running with a ipc socket.
- [add_link](./spells/add_link.spell) Adds a link to the [links](./cantrips/links) file to be used by the [youtube](./cantrips/youtube.sh) cantrip.

## Runes *(config files)*

- [aliases.zsh](runes/aliases.zsh) Aliases for z-shell.
- [fishy-2.zsh-theme](runes/fishy-2.zsh-theme) My z-shell custom theme.
- [.gitignore-global](runes/.gitignore-global) Global git ignore.
- [i3](runes/i3/config) i3 config folder.
- [i3status](runes/i3status/config) i3 status bar config folder.
- [init.vim](runes/init.vim) NeoVim configuration.
- [mpv.conf](runes/mpv.conf) mpv config.
- [startup.zsh](runes/startup.zsh) Startup commands for z-shell.
- [Xdefaults](runes/.Xdefaults) Xdefaults config (mostly urxvt).
- [zathurarc](runes/zathurarc) Zathura pdf reader config.
- [zprofile](runes/.zprofile) z-shell profile.
