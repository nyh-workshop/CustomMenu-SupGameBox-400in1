# rombuilder — your own games in the Sup 400-in-1 menu

`build_rom.py` makes an 8 MiB or 16 MiB flash image for the Sup 400-in-1 OneBus handheld. It contains:

- the original **512 KiB menu region** (`roms/…_stripped.bin`: the English menu, boot code, TFT setup, the A+B test
  program and the 400-in-1's own sound driver; everything else is `$FF`);
- **your NES games** from a CSV list, put on the **English game list**;
- **your music** (a MIDI file, converted for the 400-in-1's own sound driver) and your cursor sound;
- **your list background** (a 256 x 240 PNG).

Only the 400-in-1's own code is used. Nothing comes from the 500-in-1 project except the way the builder is packaged.
It writes the image for emulators (`.bin`, `.nes`), the game table, a flash map and a build log. On request it also
checks the image on a small OneBus model: the menu must boot, list every game on the right page, start each game with
the right banks, start the A+B test program and play the list music.

```
make                                  # the same as  make rom
make rom                              # build/rom/multicart_8M.bin + .nes + _unit.bin + _games.csv + _layout.txt + _build.log
make unit ROM=image.bin [OUT=...]     # the handheld version of any image (e.g. one of roms/*_stripped*.bin)
make rom SIZE=16                      # 16 MiB chip
make rom VERIFY=1                     # + the check on the OneBus model (VERIFY=full: every game, quick: one per kind)
make rom WAV=1                        # + build/rom/multicart_8M_music.wav, a preview of the list music
make rom SCAN=1                       # ignore custom/games.csv: every .nes in custom/games/, names cleaned, sorted
make rom CSV=... GAMES=... MUSIC=... PNG_ENGLISH=... OUT=... CUSTOM=... BASE_ROM=...   # override single items
make rom-verify OUT=my.bin            # re-check a built image on the OneBus model (from its _games.csv)
make rom-test                         # self-test of the builder (about 20 minutes)
make rom-fceux [OUT=my.bin]           # run the .nes in FCEUX itself (headless FCEUX built from source the first time)
make rom-carts                        # rebuild the test carts in examples/carts/ (needs ca65/ld65)
make games-list ROM=build/rom/multicart_8M.bin OUT=build/list      # list the games in any 400-in-1 image
make games-extract ROM=build/rom/multicart_8M.bin                  # and get them back out as .nes files
make midi-info SRC=custom/music/song.mid     # channels of a MIDI file and the default voice mapping
make wallpaper-export                 # the menu backgrounds -> wallpaper/out/ (english.png, english_guide.png, ...)
make base DUMP=<your 512 KiB dump>    # rebuild roms/..._stripped.bin from your dump (not shipped)
make rom-EnglishMenu                  # the multicart on the English-menu-only base -> build/rom/multicart_8M_EnglishMenu.bin
make EnglishMenu                      # the English-menu-only base; use it with make rom BASE_ROM=roms/..._stripped_EnglishMenu.bin
```

or directly:

```
python3 rombuilder/build_rom.py [--custom custom] [--size 8|16] [--out FILE] [--verify none|auto|full|quick] [--wav]
        [--csv FILE | --scan] [--games DIR] [--music FILE] [--wallpaper [english=]PNG] [--colors FILE] [--base roms/..._stripped.bin]
```

You need Python 3 and Pillow (wallpaper, screenshots). Nothing else: there is no assembler step, because the builder
patches the original menu in place.

## Step by step

1. Copy your `.nes` files into `custom/games/`.
2. List them in `custom/games.csv`, one line per game, in menu order. `name` and `file` are enough:
   ```
   name,file,prg_addr,chr_addr,mirroring
   MY FIRST GAME,my_first_game.nes,,,
   ,Contra (USA) (Rev 1).nes,,,           <- empty name: taken from the file name -> CONTRA
   ```
   Or delete `custom/games.csv` (or use `SCAN=1` / `--scan`). Every `.nes` file in the folder is then used once (`.nes`,
   `.NES`, `.Nes`, …), sorted by its menu name. The menu name comes from the file name, cleaned of the usual ROM-set
   labels:
   - everything in `(...)` or `[...]` is removed: country `(J)` `(U)` `(E)` `(USA)` `(Japan, USA)`, status `[!]` `[b1]`
     `[h]` `[T+Eng]`, `(Rev A)` `(PRG1)` `(v1.1)` `(Unl)`, …;
   - a trailing version or revision without brackets is removed too (`v1.1`, `Rev A`);
   - underscores become spaces; `Title, The` becomes `The Title`.

   | file | menu name |
   |---|---|
   | `Legend_of_Zelda,_The_(U)_(PRG1)_[!].nes` | `THE LEGEND OF ZELDA` |
   | `Contra (USA) (Rev 1).NES` | `CONTRA` |
   | `super_mario_bros_3_(E)_v1.1.nes` | `SUPER MARIO BROS 3` |
   | `Dr. Mario (Japan, USA) [b1].nes` | `DR. MARIO` |

   The same cleaning applies to CSV lines that leave `name` empty.

   Every scan is written out as a game list next to the games folder, with the names as the menu will show them:
   - with no `games.csv` there yet, the list **becomes `games.csv`**, and later builds use it. Edit it to rename,
     reorder or drop games, or to add the optional columns;
   - when a `games.csv` exists (`SCAN=1`), it is never overwritten. The scan goes to `games_scanned.csv`; rename it
     to `games.csv` or pass `CSV=custom/games_scanned.csv` to use it.
3. Optionally set the music in `custom/music/music.txt`, save a background as `custom/wallpaper/english.png` and set the
   list colours in `custom/wallpaper/colors.txt`.
4. Run `make` (`SIZE=16` for a 16 MiB chip, `VERIFY=1` for the check).
5. You get, in `build/rom/`:

   | file | use |
   |---|---|
   | `multicart_8M.bin` | the flash image for emulators (EmuVT) and anything that takes the plain image |
   | `multicart_8M_unit.bin` | **the image for the real handheld**: the same with the reset code's opcodes stored bit-swapped (below, "The handheld image"). Flash this one; `UNIT=0` leaves it out |
   | `multicart_8M.nes` | the same for FCEUX / NintendulatorNRS: NES 2.0, mapper 256 (OneBus), submapper 0, the whole flash as PRG-ROM, no CHR-ROM, 8 KiB PRG-RAM |
   | `multicart_8M_games.csv` | where each game went: PRG/CHR address and size, mirroring, CHR-RAM, the 8 launch bytes, the OneBus register values, the reset vector |
   | `multicart_8M_layout.txt` | a map of the flash, with what is still free |
   | `multicart_8M_build.log` | inputs (with SHA-1), the music report, ROM usage, the games table (address, size, mirroring, reset/NMI/IRQ vectors and the file offset of the reset vector, `$4100`, `$410B`, `$4107-$410A`, `$2018`, `$201A`, `$4118`, launch bytes), the check results |
   | `multicart_8M_shots/` | with `VERIFY=`: screenshots from the check (the last list page, every started game, the A+B test screen) |
   | `multicart_8M_music.wav` | with `WAV=1`: one minute of the list music, played by the built image's driver |

Each build prints how full the ROM is. If the games do not fit, the build stops before writing anything, says by how
much, and whether `SIZE=16` would do.

As shipped, `custom/games.csv` lists the builder's test carts (`rombuilder/examples/carts/`). Each one reads back its own PRG/CHR
banks (and CHR-RAM / WRAM) and shows OK or BAD, so a first `make rom` shows the whole chain working. Replace those
lines with your games.

## The game list (`games.csv`)

| column | meaning |
|---|---|
| `name` | what the list shows. Empty = from the file name (below) |
| `file` | the `.nes` file. A relative path is looked up in `custom/games/` first, then next to the CSV; or a full path |
| `prg_addr` | optional: flash address of the PRG, e.g. `0x7F8000`. Must be a multiple of the (padded) PRG size and at or above `0x080000`. Empty = automatic |
| `chr_addr` | optional: the same for the CHR (ignored for CHR-RAM games) |
| `mirroring` | optional: `H` or `V`, overrides the header. Only matters for NROM; MMC3 games set it themselves |

Lines starting with `#` are comments. Column names are not case sensitive.

**Names.** The English list font has `A-Z 0-9 space ! " & ' - . / :  @`. Names are upper-cased; other characters
become blanks, and the build log says so. A list line is 21 tiles: the number, a dot and the name, so a name can be

| games | characters |
|---|---|
| 1-9 | 19 |
| 10-99 | 18 |
| 100-500 | 17 |

Longer names are cut (with a note in the log). Names from file names are cleaned of `(...)` and `[...]` labels
(see "Step by step" above).

**Limits.**
- 1 to 500 games, 10 per page (Up/Down move, Left/Right change page, Start runs the game).
- NROM (mapper 0) and MMC3 (mapper 4); PRG up to 512 KiB, CHR up to 256 KiB, or CHR-RAM.
- The names together must fit 8 KiB (bank `$3C`); 500 names of 17 characters take 9,000 bytes, so very long lists
  with long names are refused with a message. Average up to 15 characters for 500 games.
- Several lines may use the same file (or two files with the same PRG/CHR): the data is stored once.

**Placement.** PRG and CHR are padded to a power of two and placed first-fit, each at a multiple of its own size, from
`0x080000` up to the end of the chip (`0x7FFFFF` or `0xFFFFFF`). Fixed addresses are placed first. Errors name the
game and the reason: file not found, unsupported mapper, address not aligned, inside the menu region, past the end of
the chip (with the `SIZE=16` hint), or overlapping another game.

## Music (`custom/music/music.txt`)

The English list of the original has no music. The builder gives it the **400-in-1's own sound driver** (the one the
Chinese menu uses), so the list plays a song and the cursor sound comes from the driver too.

```
song    = original          # the Chinese menu's tune  |  none  |  my_song.mid (in this folder)
options = drums=simple vol=10
cursor  = original          # the Chinese menu's cursor sound  |  none  |  cursor.txt (a sound-effect file)
```

### Preparing the MIDI

The NES has 4 voices: **pulse 1, pulse 2, triangle and noise**, each one note at a time.

- **Choosing the source of each voice yourself.** Run `make midi-info SRC=custom/music/song.mid` first. It lists every track (`t0`, `t1`, …, in file
  order, as it numbers them) with its MIDI channel, note count, range and how many notes it plays at once, and prints the
  automatic choice as a ready-made options line, for example:
  ```
   track ch   notes  range      mean  poly  name / program
   t1    1    136     55-67     62.5  2     Melody prog 80
   t2    2    128     31-43     37.0  1      prog 33
   t3    3    64      62-67     64.8  2
   t4    10   392     36-49     40.5  3      (drums)
  Automatic mapping: p1 = t1, p2 = t3, tri = t2, noise = t4
    p1=t1 p2=t3 tri=t2 noise=t4 auto=0
  ```
  Edit that line to the tracks you want, e.g. `p1=t2 p2=t1 tri=t3 noise=t4 auto=0`. A value is a track `tN`, a MIDI
  channel `1`-`16`, several joined with `+` (`t2+t5`), or `0` for silence. With `auto=0` the voices you do not name stay
  silent; without it they get the automatic choice, from the tracks you have not used.
- **Automatic choice** (voices you do not name, `auto=1`): MIDI channel 10 goes to noise (drums). Of the busiest other
  channels the lowest goes to the triangle (bass), the busiest of the rest to pulse 1 (melody) and the next to pulse 2.
- **Chords.** A voice plays one note at a time. When its source plays several at once, `pick_p1` / `pick_p2` / `pick_tri`
  say which one it keeps: `high` (default for the pulses), `low` (default for the triangle), `first` (the note held
  longest), `last` (the newest note), or a rank: `1` = highest, `2` = second highest, `-1` = lowest, `-2` = second lowest
  (where there is no note of that rank the voice rests). So one chord track can feed several voices:
  `p1=t1 pick_p1=1  p2=t1 pick_p2=2  tri=t1 pick_tri=-1`.
- **Range.** The pulses go down to C2 (MIDI 36), the triangle to C1 (MIDI 24). Notes outside are moved by octaves
  (`range=fold`, the default) or left out (`range=drop`). `transpose_p1` / `transpose_p2` / `transpose_tri` shift one voice
  by semitones (e.g. `transpose_tri=12` for a bass written low); the build log counts the notes moved or left out.
- **Tempo changes** are followed. **Drums**: GM drum notes map to noise sounds (kick, snare, toms, hi-hats, cymbals).

`options =` takes `key=value` pairs separated by spaces:

| key | default | meaning |
|---|---|---|
| `p1`, `p2`, `tri`, `noise` | auto | the voice's source: track `tN`, MIDI channel 1-16, `a+b`, or 0 (see above) |
| `transpose` | 0 | semitones for all melodic voices |
| `auto` | 1 | 1 = voices you do not name get the automatic choice; 0 = they stay silent |
| `pick_p1`, `pick_p2`, `pick_tri` | high, high, low | which note of a chord the voice keeps: `high`, `low`, `first`, `last`, or a rank `1`, `2`, … / `-1`, `-2`, … |
| `transpose_p1`, `transpose_p2`, `transpose_tri` | 0 | semitones for one voice (added to `transpose`) |
| `range` | fold | notes outside a voice's range: `fold` = moved by octaves, `drop` = left out |
| `vol`, `vol_p2`, `vol_noise` | 10, 8, 12 | top volume (1-15), scaled by note velocity |
| `duty1`, `duty2` | 2, 1 | pulse duty: 0 = 12.5%, 1 = 25%, 2 = 50%, 3 = 75% |
| `decay` | 0 | pulse notes fade over this many frames; 0 = notes sustain |
| `drums` | full | `simple` = one level for all hits: 2 bytes per hit instead of up to 6 |
| `ticks16` | auto | driver ticks per 16th note (auto aims at about 2.4 frames per tick, like the original songs) |
| `speed` | 1.0 | play faster (>1) or slower |
| `start`, `end` | - | use only this part of the MIDI, in seconds |
| `loop` | 1 | 1 = restart after the end; 0 = play once |

**Space**: the song gets 11,903 bytes (`$9181-$BFFF` of banks `$38/$39`). Typical cost
is 2-4 bytes per note; the example 64-second four-voice song takes about 3 KiB. If a song is too big the build stops
and says so: use `drums=simple`, cut it with `end=`, or simplify a busy voice.

`make rom WAV=1` writes `…_music.wav`, a preview rendered by playing the built image's driver.

### The cursor sound

A sound-effect file is plain text, `key = value`, `#` starts a comment (see `custom/music/cursor_example.txt`, which
is the original sound written out):

```
channel = pulse2        # pulse1, pulse2, triangle or noise
speed   = 2             # frames per step
duty    = 2             # pulse duty 0-3
sweep   = 08            # register 1 (hex). 08 = off; e.g. 8A slides the pitch up, 82 down
steps   = C6:12 E6:10 G6:8 C7:6      # NOTE:VOLUME per step; "-" = same pitch; noise: 0-15 instead of a note
```

Note names: `C`, `C#`/`Db` … `B` plus an octave (`C6` = 1047 Hz); a raw 11-bit period as `p1A2`. The effect may be
up to 255 bytes; a silent step is added at the end. While it plays, the music on that channel is held back; afterwards
the music takes the channel back at its next note (the original does the same). Put the effect on a voice your song
uses lightly (pulse 2 by default).

## Wallpaper (`custom/wallpaper/english.png`)

A 256 x 240 PNG in NES colours replaces the background of the game list. Start from
`custom/wallpaper/original/english.png` (or `make wallpaper-export`). Without `english.png` the original is kept.
`rombuilder/examples/wallpaper/sky.png` is an example. `custom/wallpaper/original/english_guide.png`
shows in red where the list is drawn.

The rules are the NES ones, checked by `wallpaper/wallpaper.py` with a message that names the place:
- 4 background palettes of 3 colours plus one shared backdrop colour (index 0);
- each 16 x 16 area uses one palette;
- the tiles the menu needs (the font, `$00-$2D`, and the cursor sprite `$2E`) keep their pixels, so at most the
  remaining tiles of the 4 KiB pattern table are free for the picture (repeated 8 x 8 tiles are stored once);
- the list text is drawn in colour index 3 over columns 8-28, rows 5-23: the 16 x 16 areas there must keep the text
  colour at index 3.

**The text lines cover the picture.** At run time the menu writes all 21 tiles of each list line (tile rows 5, 7, …,
23; x = 64-231), blanks included, so on those rows the picture shows the backdrop colour around the letters. The rows
in between (6, 8, …) and everything outside x = 64-231 stay as drawn. The build log notes the rows where your picture
has pixels under a text line. A dark backdrop with the busy parts of the picture outside the list column looks best.

Colour 0 of the picture is its **commonest colour under the list lines** (rows 5, 7, … 23, x = 64-231), so the cells
around the letters match what is behind them; when the picture does not fit the palettes that way, its commonest colour
overall is used (the log says so). `text_bg` in `colors.txt` sets it by hand (below).

Fixed in this version: the menu writes 32 palette bytes and byte 16 goes to PPU `$3F10`, a mirror of the backdrop
`$3F00`, written last. The importer used to leave it at `$0F`, so on every wallpaper the background and the cells
around the letters came out black. It now gets the same colour as byte 0.

## List colours (`custom/wallpaper/colors.txt`)

Optional; every line left out keeps the colour of the base image or the wallpaper. NES colour numbers in hex (`$30`,
`0x30` or `30`); `custom/wallpaper/nes_colours.png` shows all 64 with their numbers.

```
text    = $38       # the game names (original $20, white)
text_bg = auto      # the colour around the letters: auto | picture | $xx
cursor  = $2A       # the arrow (original $25, pink)
title   = $27 $30   # "400 IN 1" of the original background: letters, highlight (original $16 $20)
```

| key | what it changes | notes |
|---|---|---|
| `text` | colour 3 of every background palette under the list (columns 8-28, rows 5-23) | in the original only palette 0. With a wallpaper the import keeps this colour at index 3 there |
| `text_bg` | colour 0, the backdrop (palette bytes 0 and 16) | shared by the whole screen: every pixel of colour 0 in the picture changes with it. `auto` (default): with a wallpaper the commonest colour under the list lines, without one the base's (`$0F`); `picture`: the picture's commonest colour; `$xx`: this colour (with a wallpaper the picture's pixels of that colour become colour 0) |
| `cursor` | colour 1 of sprite palette 1 (palette byte `$15`) | the arrow is sprite tile `$2E` with attribute 1 |
| `title` | colours 2 and 1 of background palette 2 | only the original background; with a wallpaper the title is part of your picture and this line is ignored (noted in the log) |

The build stops when the text colour and the colour around it are the same (all the blacks, `$0D-$0F`, `$1D-$1F`,
`$2E/$2F`, `$3E/$3F`, count as one). `$0D` is refused (darker than black; some TVs lose sync); use `$0F`. The log shows
the result: `list colours     text $38, around the text $0C, cursor $2A, title $27 $30`.

Why one colour around all the letters: the menu writes whole 8 x 8 tiles for each name (blanks included) from the font,
whose empty pixels are colour 0, and an NES background tile cannot show the picture through it. Under the list lines
the picture is replaced by that colour, which is why a calm area behind the list looks best.

`make rom COLORS=file` uses another file; `python3 wallpaper/wallpaper.py colours IMAGE -o OUT --text $38 ...` changes
an image that is already built.

## What the builder changes

All changes are to the English menu block (CPU `$8000-$FFFF` = file `0x78000-0x7FFFF`, banks `$3C-$3F`) and to banks
`$38/$39`. Every patch checks the original bytes first and stops if they differ.

| CPU address | file | original | new | effect |
|---|---|---|---|---|
| `$FF89` | `0x7FF89` | `A2 34 8E 07 41` | `4C 7D FB` | power-on goes straight to the English list (no language select) |
| `$A940` | `0x7A940` | `A5 19 F0 11` | `4C 55 A9` | no "index ≥ 313 → index − 313" remap when starting a game |
| `$A960` | `0x7A960` | `A5 18 C9 0C` | `60` | no special launch bytes for list index 12 |
| `$F9D5` | `0x7F9D5` | `AD 27 03` | `4C E4 F9` | no boot hot-keys (A+Select, B+Select, Select+Start started fixed games) |
| `$FA92` | `0x7FA92` | `A9 0F 8D 15 40` | `20 20 E2 EA EA` | the NMI calls the sound routine at `$E220` |
| `$E220` | `0x7E220` | `$FF` × 96 | 84 bytes | sound routine: maps banks `$38/$39`, runs the driver, restores `$3C/$3D` |
| `$A28A` | `0x7A28A` | the beep (21 bytes) | `A9 84 8D 61 07 60` | the cursor beep asks the driver for effect #4 (or `60` for none) |

The list data:

| CPU | file | content |
|---|---|---|
| `$CE6B` | `0x7CE6B` | list header (16 bytes, copied to `$0600`): game count, 10 rows per page, entries pointer `$CE7B`, index limit |
| `$CE7B-$D64A` | `0x7CE7B` | 500 entries × 4 bytes: name pointer, launch row, sequence |
| `$B000-$BFFF` | `0x7B000` | 8 launch bytes per game (games 257+ use `$B800 + 8 × row`, which is the same table) |
| `$8000-$9FFF` | `0x78000` | names, ASCII, `$FF`-terminated (bank `$3C`) |

**Launch bytes** p0-p7, as the menu's start-game stub uses them (`onebus400.py`):

| byte | use |
|---|---|
| p0 | ≠ 0: CHR-RAM (`$4118 = $80`) |
| p2 | `$201A` (CHR inner mask / mode) |
| p3 | first PRG bank → `$4107-$410A` (p3..p3+3 for a 32 KiB PRG mode, else p3, p3+1, p3, p3+1) |
| p4 | `$4100` low bits: (outer PRG block << 4) \| outer CHR block, with p0 << 3 |
| p5 | `$2018` = p5 & `$F0` (CHR inner base) |
| p6 | bits 0-6: `$410B` (PRG mode); bit 7: horizontal mirroring |
| p1, p7 | not used by the stub |

The stub then sets CHR R0-R5 = 0, 2, 4, 5, 6, 7 and jumps through `($FFFC)`. The builder checks every encoding by
decoding it again (`check_roundtrip`) before it writes the image.

### Where the sound lives

The Chinese menu's driver (CPU `$E34A-$F4B1`, file `0x3E34A`) is copied to `$8000` of bank `$38` (file `0x70000`),
relocated: zero page `$CE-$FF` → `$3E-$6F`, RAM `$0300-$035B` → `$0700-$075B`, its own ROM addresses + (`$8000 − $E34A`).
None of these addresses are used by the English menu (checked with traces and the static code). Entry points after
relocation: `sound_init $802F`, `sound_play $8007`, `sfx_tick $8170`, `music_tick $834F`, `start_song $8057`.
The original song stays at its relocated place; a MIDI song goes into the free space after it. The driver's AD
command has a bug that corrupts its read pointer when it changes block; a 25-byte fix is placed after the copied block.
`$0760` (driver initialised) and `$0761` (effect request) are the routine's own flags.

## The check (`VERIFY=`)

The image runs on a small OneBus model (`emu.py`, modelled on FCEUX's `onebus.cpp`, with CHR-RAM and WRAM added):
the 6502, PRG banking (`$4100`, `$4107-$410B`, MMC3 R6/R7), CHR banking (`$4100`, `$2018`, `$201A`, R0-R5), CHR-RAM
(`$4118`), PRG-RAM at `$6000`, mirroring, the PPU memory, OAM, the controller, the NMI and the scanline IRQ. `verify.py`
checks:

- the menu boots to the English list; every page is read back from the name table and compared with the list;
- each checked game is started with Start: at the jump to its reset vector the PRG and CHR banks the CPU/PPU see must
  be the game's own data at the right places, with the right mirroring; it then runs 60 frames, and the test carts'
  OK/BAD lines are read;
- holding A+B at power-on starts the test program;
- the notes the menu writes to the APU over 25 seconds must equal those of the relocated driver running alone.

`VERIFY=full` starts every game; `quick` one game per kind (mapper, PRG size, CHR-RAM) plus games 1, 256, 257, 313,
314 and the last; `1`/`auto` is full up to 100 games, else quick. Screenshots go to `…_shots/`.

Not modelled: exact timing, the TFT and the sound chip's output (the APU register writes are compared). So the check
proves the banking, the list and the data, not every detail of a real game. `make rom-verify OUT=…` runs the same check
again on an image built earlier, from its `_games.csv`.

## Self-test (`make rom-test`)

`selftest.py` builds, in `build/rom/selftest/`:
0. the defaults from `custom/`;
1. the example list (`examples/games_example.csv`), 8 MiB, every game checked; the `.nes` header; `rom-verify` on the
   result; `tools/list_games.py` reads the list back and extracts the 9 different games, which must equal the carts;
2. `--scan` of six carts, 16 MiB (one page); the scan's `games.csv` gives the same list again; a second scan writes
   `games_scanned.csv`; ROM-set file names cleaned (`CONTRA`, `DR. MARIO`, …); the build log tables;
3. 500 games: all 50 pages read back, games 1, 256, 257, 313, 314 and 500 start;
4. a MIDI song, a cursor sound and a wallpaper chained into one build, with the WAV preview; `colors.txt` with a blue
   wallpaper and with the original background, the colours read back from the screen of the OneBus model (also the
   `$3F10` backdrop fix); a text colour equal to the colour around it is refused;
5. errors that must be refused: mapper 1, 501 games, names over 8 KiB, a misaligned / menu-region / past-the-end /
   overlapping address, 9,984 KiB of games in 8 MiB (with the `SIZE=16` hint);
6. the same big games in 16 MiB: built, 10,496 of 16,384 KiB used.

## FCEUX check (`make rom-fceux`)

`make rom-fceux` runs the `.nes` in **FCEUX itself**:
- `fceux/build.sh` fetches FCEUX at a fixed commit (`ffc23f0`) from https://github.com/TASEmulators/fceux and compiles
  its core with a small headless front end (`fceux/headless.cpp`), so no SDL or Qt is needed. It needs git, g++ and
  zlib (Linux, or MSYS2 / Cygwin on Windows).
- `fceux/check.py` then boots the list and steps to each game with the pad (RIGHT = next page, DOWN, START; each
  button held 7 frames, because the menu reads the pad every 7th frame). It checks that the cursor is on the right list
  entry (`$064D + 2 × cursor_row`), reads the test carts' OK/BAD lines from FCEUX's nametable, and writes a contact
  sheet `<rom>_fceux.png`.

The CHR-RAM test cart shows BAD in FCEUX, which is expected: FCEUX's OneBus mapper ignores `$4118`, so it has no
CHR-RAM. The pad / list logic of `check.py` was tried here against the OneBus model standing in for FCEUX (30 games,
three pages: all OK); FCEUX itself could not be built where this was prepared.

## The handheld image (`_unit.bin`, `rombuilder/unit.py`)

The Sup 400-in-1 powers on with its opcode decoder scrambled: every **opcode** byte the CPU fetches is read with bits
4 and 5 swapped; operands and data are read as they are. The reset code switches it off with `lda #$05 / sta $411C`,
and everything after that runs plain. The project's dump has the swap undone, as emulators start plain, so the
handheld image stores the reset code's opcodes swapped again:

| CPU | file | emulator (`.bin`) | handheld (`_unit.bin`) | |
|---|---|---|---|---|
| `$E7E0` … `$E7E9` | 0x7E7E0 | `4C E3 E7` … `4C D0 FF` (4 × jmp) | the same | `4C`: bits 4 = 5 |
| `$FFD0` … `$FFD6` | 0x7FFD0 | `4C D3 FF` … `4C D9 FF` (3 × jmp) | the same | |
| `$FFD9`, `$FFDA` | 0x7FFD9 | `EA`, `EA` (nop) | `DA`, `DA` | swapped |
| `$FFDB` `$FFE0` `$FFE5` `$FFEA` | 0x7FFDB … | `A9 D0`, `A9 DC`, `A9 81`, `A9 05` (lda #) | `99 D0`, `99 DC`, `99 81`, `99 05` | swapped |
| `$FFDD` `$FFE2` `$FFE7` `$FFEC` | | `8D 34 41`, `8D 2D 41`, `8D 37 41`, `8D 1C 41` (sta) | the same | `8D`: bits 4 = 5 |

So 6 bytes differ (file 0x7FFD9, 0x7FFDA, 0x7FFDB, 0x7FFE0, 0x7FFE5, 0x7FFEA). The rule was taken from the handheld's own
flash at 0x70000-0x7FFFF (read from the unit, SHA-1 `ff31d036…`): the original block with the rule applied equals it
byte for byte, and those 6 bytes are the only difference. Every build checks, and logs:

1. the rule applied to `menu/orig/` (the original block) gives the unit's flash (by its SHA-1, or byte for byte with
   `UNIT_DUMP=<the unit's 0x70000-0x7FFFF>`);
2. the build's reset code (17 opcodes from the reset vector `$E7E0` to `sta $411C`) is the original, so its stored bytes
   are the unit's;
3. only those opcodes differ from the emulator image;
4. on the OneBus model, started scrambled as the handheld starts, the handheld image runs exactly like the emulator
   image on a plain start (same CPU path and screen after 240 frames); on a plain start it stops at `$FFD9` (`DA`).

The swap is the same in both directions, so `make unit ROM=<handheld image>` turns a handheld image back into an
emulator image too. The 500-in-1 swaps other bits (7↔6 and 2↔1); this one swaps 4↔5.

## Not included yet

- **NSF music.**
- **FCEUX and CHR-RAM games:** FCEUX's OneBus mapper ignores `$4118`, so CHR-RAM games show wrong graphics there.
  The OneBus model and the original menu both use it (the original's JACKAL entry, for one, uses CHR-RAM).

## Files

| file | what |
|---|---|
| `build_rom.py` | the builder |
| `onebus400.py` | iNES parsing, launch-byte encode / decode, padding, round-trip check |
| `menu400.py` | the menu patches and the list data (header, entries, names, launch table) |
| `english_sound.py` | the 400-in-1 sound driver copied and relocated for the English list, and its NMI hook |
| `emu.py`, `verify.py` | the OneBus model and the checks (`make rom-verify OUT=…` re-checks an image) |
| `selftest.py` | `make rom-test` |
| `fceux/` | `build.sh` (headless FCEUX from source), `headless.cpp` (its front end, GPL like FCEUX), `check.py` (`make rom-fceux`) |
| `examples/games_example.csv`, `examples/carts/` | the test-cart list and the self-checking test carts (`examples/make_test_carts.py`: `make rom-carts`, needs ca65/ld65) |
| `examples/music/`, `examples/wallpaper/` | a MIDI file, a cursor sound and a wallpaper for trying the music and wallpaper chain |

The builder also uses `../music/menu_music.py` + `sndlib.py` (MIDI and sound-effect conversion, the APU player),
`../wallpaper/wallpaper.py` (the list background) and `../tools/op6502.py`.
