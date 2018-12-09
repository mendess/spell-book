# scripts
 A collection of scripts I like to keep handy

## Spells *(scripts)*

- [autoUpdateTex](autoUpdateTex.sh) A simple script that rebuilds a
  latex pdf every time it changes.
- [changeMeWall](changeMeWall.sh) Changes the wallpaper to a random one in the
  `~/Pictures/Wallpapers` folder.
    - *[changeMeWallCicle](changeMeWallCicle.sh) runs this every 5 minutes.*
- [backmeup](backmeup.sh) Backs up (to git) changes to the spells and runes.
- [updatespellbook](updatespellbook.sh) Tries to synchronise with changes to the
  remote repository. Also runs [updatespellbook](updatespellbook.sh)
  and [castRunes](castRunes.sh).
- [sssh](sssh.sh) Manages ssh connections.
- [learnspells](learnspell.sh) Creates a sym-link on `~/.local/bin` to every
  spell.
- [castRunes](castRunes.sh) Creates a sym-link for every rune in
  [runes](runes/). The location of the sym-link depends on the rune and is
  defined in the script.

## Runes *(config files)*

- [aliases.zsh](runes/aliases.zsh) Aliases for z-shell.
- [init.vim](runes/init.vim) NeoVim configuration.
- [startup.zsh](runes/startup.zsh) Startup commands for z-shell.
