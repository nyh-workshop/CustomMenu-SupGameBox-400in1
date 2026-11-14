# custom/ — everything you change for your own ROM

Put your files here, then run **`make rom`** (or just `make`) in the project folder. Nothing else needs editing.

```
custom/
  games.csv              your game list, in menu order (delete it to use every .nes in games/, sorted by name)
  games/                 your .nes files (NROM and MMC3)
  music/music.txt        the list music and the cursor sound (+ your .mid and sound-effect files, next to it)
  wallpaper/english.png  the game-list background (optional; start from wallpaper/original/english.png)
  wallpaper/colors.txt   the list colours: names, around the names, cursor, title (optional; all lines commented out)
```

`make rom` writes to `build/rom/`:

| file | use it for |
|---|---|
| `multicart_8M.bin` | emulators (EmuVT) and anything that takes the plain image |
| `multicart_8M_unit.bin` | **the real handheld**: flash this one (the reset code stored with bit-swapped opcodes; `UNIT=0` leaves it out) |
| `multicart_8M.nes` | FCEUX / NintendulatorNRS (mapper 256) |
| `multicart_8M_games.csv` | where every game went, with its launch bytes |
| `multicart_8M_layout.txt` | the flash map, with what is free |
| `multicart_8M_build.log` | the whole build report |

Each build prints how full the ROM is. If the games do not fit, it stops and says by how much, and whether `SIZE=16`
would do. Options: `SIZE=16`, `VERIFY=1` (check the image on the OneBus model), `WAV=1` (music preview),
`SCAN=1`, `OUT=build/rom/my.bin`. `make rom-fceux` runs the `.nes` in FCEUX; `make games-list ROM=build/rom/multicart_8M.bin`
lists what is in a built image.

## Games: `games.csv` and `games/`

```
name,file,prg_addr,chr_addr,mirroring
MY GAME,my_game.nes,,,
,Contra (USA) (Rev 1).nes,,,         <- empty name: taken from the file name -> CONTRA
```

- **Names:** the font has `A-Z 0-9 space ! " & ' - . / : @`. Up to 19 characters for games 1-9, 18 for 10-99, 17 from
  game 100 on. Lower case is upper-cased; other characters become blanks (the log says which).
- **Without a CSV:** every `.nes` in `games/` is used (`.nes`, `.NES`, …), named from the file name with `(U)`, `[!]`,
  `(Rev A)`, `_` and the like cleaned away. That scan is also written out as a game list:
  - with no `games.csv` here, it **becomes `games.csv`**. Edit it (names, order, delete lines) and the next
    `make rom` uses it;
  - with `make rom SCAN=1` while a `games.csv` exists, your list is left alone and the scan goes to
    **`games_scanned.csv`**. Rename it to `games.csv` (or build with `CSV=custom/games_scanned.csv`) to use it.

  So a quick way to start: copy your `.nes` files into `games/`, delete the shipped `games.csv`, run `make rom`, then
  tidy the names in the new `games.csv`.
- **Limits:** 1-500 games, 10 per page; NROM and MMC3, PRG up to 512 KiB, CHR up to 256 KiB or CHR-RAM; the names
  together up to 8 KiB (about 15 characters per name with 500 games).
- `prg_addr`, `chr_addr`, `mirroring`: optional, see `../rombuilder/README.md`.

As shipped, the list holds the builder's test carts (`../rombuilder/examples/carts/`), which show OK / BAD for their own banks.
Replace those lines with your games.

## Music: `music/music.txt`

```
song    = original     # or none, or my_song.mid (a MIDI file in music/)
options =              # MIDI options, e.g.  p1=t1 p2=t3 tri=t2 noise=t4 auto=0 drums=simple end=60
cursor  = original     # or none, or cursor.txt (a sound-effect file in music/; see cursor_example.txt)
```

To decide which MIDI track plays on which NES voice, run `make midi-info SRC=custom/music/my_song.mid`: it lists the
tracks (`t1`, `t2`, …) and prints the automatic choice as an options line to edit, e.g.
`options = p1=t2 p2=t1 tri=t3 noise=t4 auto=0`. `pick_p1=` / `pick_p2=` / `pick_tri=` choose which note of a chord a
voice keeps (`high`, `low`, `first`, `last`, or `1`, `2`, `-1` …).

The list uses the 400-in-1's own sound driver: 4 voices (pulse 1, pulse 2, triangle, noise), about 11.9 KB for the
song. All options:
`../rombuilder/README.md`, "Music".

## Wallpaper: `wallpaper/english.png`

Copy `wallpaper/original/english.png` to `wallpaper/english.png` and edit it: 256 x 240, NES colours, 4 palettes of
3 colours plus one backdrop colour, one palette per 16 x 16 area. `wallpaper/original/english_guide.png` shows in red
where the menu draws the list. The list
text (colour index 3) is drawn on tile rows 5, 7, … 23 between x = 64 and 231; on those rows the picture shows the
backdrop colour around the letters. The builder stops with a message naming the place if a rule is broken.

## List colours: `wallpaper/colors.txt`

Remove the `#` in front of a line to use it. `wallpaper/nes_colours.png` shows the 64 NES colours with their numbers.

```
text    = $38       # the game names (original $20, white)
text_bg = auto      # the colour around the names = the picture's background colour 0
cursor  = $2A       # the arrow (original $25, pink)
title   = $27 $30   # "400 IN 1" of the original background: letters, highlight
```

`text_bg = auto` (the default) takes the colour that covers most of your wallpaper under the list lines, so the names
sit on the same colour as the picture behind them. Details: `../rombuilder/README.md`, "List colours".
