# OneBus Sup 400-in-1 — rebuildable menu source and custom multicart builder

The menus of a OneBus (VT02/VT03) famiclone handheld "Sup 400-in-1" (dump of 2024-10-04), as assembly source that
rebuilds the original byte for byte, plus the tools to make your own cartridge image from it: your games, your music and
your background on the 400-in-1's own English list. Laid out like the 500-in-1 project.

## Quick start: your own ROM

Everything you change is in **`custom/`** (see `custom/README.md`):

| put here | what |
|---|---|
| `custom/games/` + `custom/games.csv` | your `.nes` games (NROM / MMC3) and the list in menu order. Delete `games.csv` (or use `SCAN=1`) to take every `.nes` in the folder; that scan is written back as `games.csv` (or `games_scanned.csv` if a `games.csv` exists) for you to edit |
| `custom/music/music.txt` (+ your `.mid` and cursor-sound file next to it) | the list music and the cursor sound, played by the 400-in-1's own sound driver |
| `custom/wallpaper/english.png` | the game-list background (start from `custom/wallpaper/original/english.png`) |
| `custom/wallpaper/colors.txt` | the list colours: names, the colour around them, cursor, title (`nes_colours.png` lists the 64 colours) |

```
make rom            (or just  make)
```

writes, in `build/rom/`:

| file | for |
|---|---|
| `multicart_8M.bin` | emulators (EmuVT) and anything that takes the plain flash image |
| `multicart_8M_unit.bin` | **the real handheld**: flash this one (reset code stored with bit-swapped opcodes) |
| `multicart_8M.nes` | FCEUX / NintendulatorNRS (NES 2.0, mapper 256) |
| `multicart_8M_games.csv`, `_layout.txt` | where every game went (with its launch bytes and OneBus register values), the flash map |
| `multicart_8M_build.log` | inputs, ROM usage, the music report, a table of every game with its address, vectors and OneBus register values, the check results |

Every build prints the ROM usage (KiB and % of the 8 / 16 MiB). It stops before writing anything when the games do not
fit, and says whether `SIZE=16` would be enough.

Options: `SIZE=16` (16 MiB chip), `VERIFY=1` (also check the image on the OneBus model: every list page, the games
started, the A+B test program, the music; slower), `WAV=1` (music preview), `SCAN=1`, `OUT=…`. `make rom-fceux` runs the
`.nes` in FCEUX itself. As shipped, `custom/` holds the builder's self-checking test carts, so a first `make rom` shows
the whole chain working.

Needs Python 3 and Pillow. cc65 2.19 (on PATH, or `CC65=/path/to/cc65/bin`) is used for the source rebuilds when it is
there; without it they run `tools/asmcheck.py` (below). `make rom` itself needs no assembler: it patches the original
menu in place.

## What is here

| folder | what |
|---|---|
| `custom/` | **your** games, music and wallpaper for `make rom` |
| `roms/` | the 512 KiB dump (opcode bit swap undone), its stripped copy (the base of `make rom`) and the English-menu-only stripped copy (`make EnglishMenu`; `roms/README.md`, in detail `roms/STRIPPED.md`); what the stripped copy still holds that no menu uses (`roms/LEFTOVERS.md`) |
| `menu/` | file 0x70000-0x7FFFF: the **English menu** + boot code (banks `$3C-$3F`) as ca65 source (`menu/README.md`) |
| `menu_cn/` | file 0x30000-0x3FFFF: the **Chinese menu** (banks `$1C-$1F`) + its sound driver as ca65 source |
| `TestApp/` | file 0x68000-0x6FFFF: the **language select** and the Aaronix A+B **"MAIN DEVICE TEST"** (banks `$34-$37`) |
| `tft_driver/` | the **TFT panel driver** (bank `$15`, file 0x2A000) and **boot stage 2** (bank `$33`, file 0x66000) |
| `identical/` | frozen copy of those four source folders with its own `make` that proves the 100% match (`identical/README.md`) |
| `reference/` | readable C of the menus, the test program, the TFT driver and the sound driver (not byte-exact) |
| `sound/` | the menu sound driver: how it works, where the data is, NSF / raw / text extraction (`sound/SOUND.md`) |
| `music/` | MIDI songs and sound effects for the original menus (`music/README.md`); the builder uses it for the English list |
| `wallpaper/` | the three menu backgrounds to / from PNG (`wallpaper/README.md`) |
| `rombuilder/` | the multicart builder behind `make rom`, its OneBus model, checks, FCEUX check and test carts (`rombuilder/README.md`) |
| `data/` | the original game list read from the menu (`data/games.csv`, `data/GAMES.md`) and the notes on the two lists (`data/400in1_game_lists.md`) |
| `tools/` | `asmcheck.py`, `build_blocks.py`, `list_games.py`, `strip_rom.py`, `check_reference.py`, `capcom_compare.py`, `cmpbin.py`, `op6502.py`; `strip_checks/` (boot comparison of the stripped images, `make strip-check`; content audit, `make strip-audit`; the trace scanner); `cn_hidden_screens/` (the `$4119` test and the hidden Chinese screens) |

## The menu region from source (byte-identical)

Reference: each block's **`orig/` file**, the original bytes of the dump at that place, pinned by its SHA-1 in
`tools/build_blocks.py`. The full 512 KiB dump (`romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin`,
SHA-1 `ecb67c77…`) is no longer shipped; give your copy with `DUMP=` and every check also runs against all 512 KiB.

| block | file range | source | from source |
|---|---|---|---|
| `menu` | 0x70000-0x7FFFF | `menu/src/main.s` + `menu64k.cfg` | 0x78000-0x7FFFF (English menu); 0x70000-0x77FFF `.incbin` |
| `menu_cn` | 0x30000-0x3FFFF | `menu_cn/src/main.s` + `menu_cn64k.cfg` | 0x38000-0x3FFFF (Chinese menu); 0x30000-0x37FFF `.incbin` (menu data) |
| `testapp` | 0x68000-0x6FFFF | `TestApp/src/main.s` + `langsel_test32k.cfg` | all 32 KiB |
| `boot` | 0x66000-0x67FFF | `tft_driver/src/main_b33.s` + `bank8k.cfg` | all 8 KiB |
| `tft` | 0x2A000-0x2BFFF | `tft_driver/src/main_tft.s` + `bank8k.cfg` | all 8 KiB |

```
make verify [DUMP=…] all five blocks (against orig/), the blocks in the stripped image, both stripped images made again;
                     with DUMP= also all 512 KiB of the dump
make menu | menu-cn | testapp | boot | tft | blocks | image
make identical       the same from the frozen copy in identical/
make custom [ROM=…] [OUT=…]   your edited sources into a copy of the stripped image (no match check; lists what changed)
cd menu && make verify        one block with cc65 alone (each folder's own Makefile; `make check` there = asmcheck)
```

`ASM=ca65` requires cc65, `ASM=check` uses only asmcheck, `ASM=both` requires both; the default (`auto`) runs ca65 +
ld65 when they are found and asmcheck always. When both ran, their outputs must also be equal.

### Result (2026-11-11, with the dump; 2026-11-14 without it)

| check | result |
|---|---|
| `menu` 0x70000-0x7FFFF (64 KiB) | **IDENTICAL** |
| `menu_cn` 0x30000-0x3FFFF (64 KiB) | **IDENTICAL** |
| `testapp` 0x68000-0x6FFFF (32 KiB) | **IDENTICAL** |
| `boot` 0x66000-0x67FFF (8 KiB) | **IDENTICAL** |
| `tft` 0x2A000-0x2BFFF (8 KiB) | **IDENTICAL** |
| the five blocks put into a copy of the dump, all 524,288 bytes (`DUMP=`) | **IDENTICAL** (112 KiB of it assembled from source) |
| without the dump: the five blocks put into the stripped image and stripped again | **IDENTICAL** to `roms/…_stripped.bin` |
| `identical/` (frozen copy, its own `make`) | **IDENTICAL** |
| every block's `orig/` file = the same bytes of the dump | yes |
| both stripped images made again (`make base-check`; from the dump with `DUMP=`, else from the stripped image) | **identical** to `roms/…_stripped.bin` and to `roms/…_stripped_EnglishMenu.bin` |
| the eight builder test carts made from `rombuilder/examples/make_test_carts.py` with asmcheck | **IDENTICAL** to the carts shipped in `rombuilder/examples/carts/` (taken from the 500-in-1 project, whose generator calls ca65 / ld65) |
| readable C in `reference/` (`make reference-check`) | all 8 files compile (gcc `-std=c99 -fsyntax-only`) |

**How it was checked.** cc65 is not installed where this was prepared, and nothing could be installed. So the sources
were assembled with **`tools/asmcheck.py`**, written for this: a strict stand-in for ca65 + ld65 that reads the same
files by the same rules —
- the `.include` / `.incbin` chain from `main.s` with ca65's `-I` / `--bin-include-dir` search;
- labels, equates, `.byte` / `.word` / `.res` / `.segment` / `.setcpu`, character constants;
- ca65's address-size rules (constants and equates by value, labels and forward references absolute, `a:` / `z:`);
- legal 6502 opcodes only, with range errors for immediates, `.byte` values and branches;
- symbols defined twice are an error;
- the ld65 config's MEMORY / SEGMENTS: placement order, fill, overflow, segments missing from the config.

Anything it does not know (a macro, another directive) stops it with an error instead of being guessed. It also
rebuilds the test carts taken from the 500-in-1 project byte for byte from their generator, and the block Makefiles' own
`make && make verify` flow was run through it as well (with stand-in `ca65` / `ld65` commands).

**The real ca65 / ld65** (cc65 V2.19, run by you on 2026-11-14): `menu`, `testapp`, `boot` and `tft` IDENTICAL and
equal to asmcheck's output. `menu_cn` stopped with *Range error (Address size 2 does not match fragment size 1)* at two
branches from bank `$1E` into bank `$1F` (`beq loc_E005` at `$DFC9`, `beq loc_E03A` at `$DFD4`): the banks are separate
segments, and ca65 does not encode a branch to a label in another segment. Both are now written as bytes
(`.byte $F0,$3A` / `.byte $F0,$64`, the instruction in the comment), in `menu_cn/` and `identical/menu_cn/`, and
asmcheck now stops on such a branch with the same message. No other branch in the five blocks crosses a segment.

## Building blocks of the builder

- **The handheld image** (`unit.py`): `<out>_unit.bin`, the built image with the 6 reset-code opcodes at
  `$FFD9-$FFEA` stored with bits 4/5 swapped, as the unit's flash has them (it powers on with a scrambled opcode
  decoder until `sta $411C`). Checked against the unit's own 0x70000-0x7FFFF and on the OneBus model started scrambled.
  `make unit ROM=…` converts any image; `UNIT=0` leaves it out.
- **The menu** (`menu400.py`): the English menu is patched in place. Power-on goes straight to the English list; the
  original's "index ≥ 313 → index − 313" remap, the index-12 special case and the boot hot-keys are removed. Up to 500
  games, 10 per page.
- **The list** (`menu400.py`): the header at `$CE6B`, 500 entries at `$CE7B`, names in bank `$3C`, 8 launch bytes per
  game at `$B000` (`onebus400.py` encodes them and decodes them again before writing).
- **The sound** (`english_sound.py`): the Chinese menu's own driver is copied, relocated, into banks `$38/$39` and
  called from the English NMI; your MIDI song and cursor sound go with it (`music/menu_music.py`).
- **The wallpaper** (`wallpaper/wallpaper.py`): imported into the English screen before the patches. Colour 0 (around
  the names) is the commonest colour under the list lines; palette byte 16 (`$3F10`, the backdrop mirror) now gets it
  too, so the picture's background is no longer forced to black.
- **The list colours** (`custom/wallpaper/colors.txt`, `COLORS=`): text, `text_bg`, cursor, title, written into the
  English screen's palette (`rombuilder/README.md`, "List colours").
- **The checks** (`rombuilder/verify.py` on `rombuilder/emu.py`), the self-test (`make rom-test`), the FCEUX check
  (`make rom-fceux`), and `make games-list` / `make games-extract`, which read the list (and the games) back out of any
  400-in-1 image: the original dump or a built multicart.

Details and every patched byte: `rombuilder/README.md`.

## Tools at a glance (make targets)

| target | does |
|---|---|
| `make rom` (= `make`) | your multicart from `custom/` (`VERIFY=1` to check it on the model, `WAV=1`, `SCAN=1`, `SIZE=16`) |
| `make rom-verify` / `make rom-test` / `make rom-fceux` / `make rom-carts` | re-check a built image / self-test of the builder / run the `.nes` in FCEUX / rebuild the test carts |
| `make games-list [ROM=…]` / `make games-extract ROM=…` | the game list of an image → `data/` (or `OUT=`) / its games as `.nes` files |
| `make verify` / `make identical` | the menu region from source, compared with the original (`orig/`; all 512 KiB with `DUMP=`) |
| `make menu`, `menu-cn`, `testapp`, `boot`, `tft`, `blocks`, `image` | single blocks / all / all + the 512 KiB image |
| `make custom [ROM=…]` | your edited sources into a copy of the stripped image |
| `make base DUMP=…` / `make base-check` | make the stripped base / check both stripped images against the shipped ones |
| `make strip-check [DUMP=…]` | boot the stripped image and the English-menu-only image (and your dump) on the OneBus model and compare them |
| `make strip-audit [SF2010=…]` | content audit of both stripped images: no Capcom bank, no Street Fighter 2010 tiles, nothing outside the keep map, only two images |
| `make unit ROM=… [OUT=…]` | the handheld version of any image (reset opcodes bit-swapped); `make rom` writes `_unit.bin` itself |
| `make rom-EnglishMenu [SIZE=… VERIFY=… …]` | the multicart on the English-menu-only base -> `build/rom/multicart_8M_EnglishMenu.bin` |
| `make EnglishMenu [DUMP=…]` | the English-menu-only stripped image (no Chinese menu, no language select); `make rom BASE_ROM=roms/…_EnglishMenu.bin` builds on it |
| `make midi-info`, `music`, `music-preview`, `music-export`, `music-test` | the music tools on their own (`music/README.md`) |
| `make wallpaper-export`, `make wallpaper` | the wallpaper tool on its own (`wallpaper/README.md`) |
| `make reference-check` | compile the readable C |
| `make cn-screens` | the hidden Chinese screens forced on the model (`tools/cn_hidden_screens/`) |
| `make capcom-compare ROMS="a.nes b.nes"` | is the dormant bank `$1C` (Capcom's sound engine + 7 songs; it is Mighty Final Fight's) from one of these games? Compares the engine code, the sound list and the songs (`tools/capcom_compare.py`, `sound/SOUND.md`) |
| `make clean` | remove `build/` |

## Not included yet

- **NSF music** as a source for the list music.
- **Byte-identical C** like the 500-in-1's `lib/`: the 400-in-1 sources are assembly; `reference/` is readable C only.
- **FCEUX and CHR-RAM games:** FCEUX's OneBus mapper ignores `$4118`, so CHR-RAM games show wrong graphics there.
- Register meanings outside OneBus PRG/CHR banking (`$41xx`, `$42xx`, `$4FF0-$4FFA`, `$4119`) are recorded with observed
  values only.
