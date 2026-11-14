# The stripped images in detail

(This was the separate `400in1_stripped` folder; `roms/README.md` is the short version. Paths are from the package folder.)

`romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin` is the 512 KiB dump with every area that the
language select, the English and Chinese menus, the boot/TFT code and the Aaronix test app don't use set to `$FF`.

| | |
|---|---|
| Not `$FF` | 266.3 KiB (272,688 bytes) |
| Changed from the dump | 189,961 bytes |
| SHA-1 | `acd69628491faa86c2517035fc0791023a4bc282` |
| Rebuild | `make base` (`python3 tools/strip_rom.py IN_512KiB.bin OUT.bin`); `make base-check` compares |

`romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped_EnglishMenu.bin` is the same for the English list
only (last section): 62.9 KiB (64,444 bytes) not `$FF`, SHA-1 `78f44eac8ab1f1ee408fc12a95a01c8ad1fe0dea`, rebuilt
with `make EnglishMenu` (`python3 tools/strip_rom.py --english-menu IN_512KiB.bin OUT.bin`).

## What is kept

| File range | Bank(s) | Contents | Why it is needed |
|---|---|---|---|
| 0x00000-0x28FFF | CHR | Chinese menu: 40 list pages of 4 KiB + sprites | Page *n* uses 1K banks *n*x4..+3 (traced: page 1 only), sprites `$A0-$A3`. Static sprite/screen banks `$0A-$0D`, `$7E-$81`, `$84-$87` are in this range |
| 0x2A000-0x2BFFF | `$15` | TFT detection and init, panel tables, name strings | All panel types, not just the one FCEUX takes |
| 0x30000-0x37FFF | `$18-$1B` | Chinese menu data | Paged at `$8000` (`$4107` = `$38-$3B`): list pages, screen records, second (ASCII) list |
| 0x3A000-0x3FFFF | `$1D-$1F` | Chinese menu data, code, sound driver and song, vectors | |
| 0x62000-0x63FFF | `$31` | English menu CHR | `$2018=$10` / `$201A=$8E` can reach this whole range (traced: 0x62000-0x62FFF) |
| 0x66000-0x67FFF | `$33` | Boot stage 2 (`$A000`) + language-select CHR | |
| 95 tiles of 0x68000-0x68FFF | `$34` | The Aaronix test app's CHR: only the tiles it can show | See "Bank `$34`" below and `TestApp/chr/bank34_used_tiles.png` |
| 0x6A000-0x6FFFF | `$35-$37` | Language select, test app, sound copy | Includes bank `$36`, the source of the test app's ROM-read test |
| 0x78000-0x7FFFF | `$3C-$3F` | English menu: names, launch tables, code, reset/NMI, vectors | Also used by the Chinese menu's game launch (`$AAB1`) |

## What is filled with `$FF`

Also filled since 2026-11-14: **bank `$1C`** (0x38000-0x39FFF), Capcom's sound engine with Mighty Final Fight's sound
list and songs (never called; `menu_music.py` still writes new Chinese-menu songs there), and **841 Street Fighter 2010
tiles** of the menu backgrounds (see the last section).

| File range | Bank(s) | Was | Evidence |
|---|---|---|---|
| 0x29000-0x29FFF | (CHR) | Unused tiles (another copy of the "400 IN 1" logo) | No CHR setting of any menu reaches it |
| 0x2C000-0x2FFFF | `$16-$17` | **GOBLET TOWER** PRG (launch row 311) | Its CHR is outside the 512 KiB |
| 0x40000-0x5FFFF | `$20-$2F` | **MARIO 3** CHR (128 KiB, row 7) | Its PRG is outside |
| 0x60000-0x61FFF | `$30` | Unknown, starts with a pointer table like bank `$16` | Nothing reads it: no trace, no menu bank setting, no launch row |
| 0x64000-0x65FFF | `$32` | **SPIDER MAN** CHR (row 22) | |
| 0x70000-0x77FFF | `$38-$3B` | **SPIDER MAN** PRG (32 KiB) | |
| 417 tiles of 0x68000-0x69FFF | `$34` | Test-app CHR tiles it never shows: all of 0x69000-0x69FFF and the gaps in 0x68000-0x68FFF (5,994 bytes changed) | Never read as PRG; never on screen in any test-app state (below) |

**Effect on the game list.** These list entries start a game whose data was in the filled areas, so on the stripped image
they won't run:

| Entry | Shown as | Launches |
|---|---|---|
| #2 | MARIO 3 | MARIO 3 |
| #315 | "CONTRA FORC" | MARIO 3 |
| #27 | SPIDER MAN | SPIDER MAN |
| #340 | "90 TANK" | SPIDER MAN |
| #312 | GOBLET TOWER | GOBLET TOWER |

The same games in the Chinese menu are affected, since it launches through the English tables. The two odd names come from
the English launch code: from entry 313 on, it reuses the first table (index − `$139`).

Every other launch row points outside the first 512 KiB (`$4100` ≠ 0), so it is unaffected.

## How the keep map was decided

1. **Traces.** Each of the four FCEUX traces was replayed with the OneBus PRG and CHR rules. The game-launch trace was cut at
   the first non-zero `$4100` write, where the game starts. Recorded:
   * every executed byte;
   * every ROM data read;
   * every `JMP (ind)` pointer;
   * every CHR 1 KiB bank in a pattern table the PPU uses while rendering, plus `$2007` CHR access.

   **None** of those 15,000-odd PRG bytes and 44 CHR banks lies in a filled area.
2. **Static bank writes.** Every write to `$4100`, `$4107-$410B` and `$2012-$201A` in the disassemblies was checked:
   * Chinese menu: `$4107` = `$38-$3B` (`$3C` in the NMI).
   * English menu: banks `$3C-$3F`; `$34-$37` (language select); `$14/$15` (TFT); and game launches with `$4100` ≠ 0.
   * TFT and boot code never touch `$8000-$9FFF` and never switch banks.
3. **Launch tables.** All 505 launch rows at 0x7B000 were decoded. Only the three games above keep data inside this file.

## Checks on the stripped image

* **Full boot, all images** (`make strip-check`, `tools/strip_checks/bootcmp.py`). The OneBus model
  (`rombuilder/emu.py`) runs each image from the reset vector with the same button script and compares every executed
  address, every APU write and every screenshot:

  | Run | Compared with | Result |
  |---|---|---|
  | Language select | the dump with only the Street Fighter 2010 tiles blanked | identical |
  | Chinese menu (pages 1 → 8 and back) | the same | identical; this uses list pages and CHR the traces never reached |
  | Test app (A+B at power-on) | the same | identical |
  | English menu (boot patch made in memory; 40 pages, a game start) | the same | identical |
  | English-menu-only image: English list (40 pages, a game start), test app | the stripped image with the boot patch | identical |

  Screenshots of the stripped image go to `build/strip_checks/`.
* **Tools.** `music/menu_music.py` (songs, cursor sound), `wallpaper/wallpaper.py` and the ROM builder (`make rom`,
  `make rom-test`) work on the stripped images.
* **Not run on hardware.**

## Files

* `roms/romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin`: the stripped image (`make base`).
* `roms/romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped_EnglishMenu.bin`: the English-list-only
  image (`make EnglishMenu`).
* `tools/strip_rom.py`: the keep map and the stripper (`--english-menu` for the second image).
* `tools/strip_checks/bootcmp.py`: the boot comparison above (`make strip-check`).
* `tools/strip_checks/audit.py`: the content audit below (`make strip-audit [SF2010=its CHR]`).
* `tools/strip_checks/fullscan.py TRACE LABEL`: the trace scanner of step 1 of "How the keep map was decided". It reads an
  FCEUX trace log (`A:.. X:.. Y:.. S:.. $BB:AAAA: bytes  op ...`); the four traces themselves are not included, their
  results are (`menu/tools/trace_coverage_en.json`, `menu_cn/tools/trace_coverage_cn.json`, `TestApp/tools/`, `tft_driver/tools/`).
* `TestApp/chr/bank34_used_tiles.png`, `TestApp/chr/bank34_stripped.png`: bank `$34` tile by tile.
* `roms/sf2010_removed_before_after.png`: the three screens before and after the Street Fighter 2010 tiles were blanked.

## Bank `$34`: the test app's CHR, tile by tile

Bank `$34` (0x68000-0x69FFF) is never executed or read as PRG. The test app maps it as CHR (`$2018=$10`, `$201A=$A6`,
1K banks `$1A0-$1A7`) and takes both its background and its 8x8 sprites from 0x68000-0x68FFF. The language select and
the menus never map it.

It can show **95 of the 512 tiles** (tile n at 0x68000 + 16n). `TestApp/chr/bank34_used_tiles.png` marks them in green;
`TestApp/chr/bank34_stripped.png` shows the bank after the fill.

| Tiles | Used for |
|---|---|
| `$00-$09` | digits: A/B press counts (BCD, any digit), the sprite test rows `0`-`7`, CHANNEL-1..5, the error sprites |
| `$0A-$0E`, `$11`, `$12`, `$15-$18`, `$1B-$1D`, `$1F`, `$21` | letters A B C D E H I L M N O R S T V X: "MAIN DEVICE TEST", "CHANNEL", "AARONIX", the button labels |
| `$24` | `-` in CHANNEL-n |
| `$30`, `$35` | space (screen fill), the dashed line |
| `$31`, `$32`, `$33`, `$36` | sprites: pad 1 bit (`$30`/`$31`), pad 2 bit (`$32`/`$33`), the press-rate bar |
| `$50-$53` | highlighted O / S / A / B when a button is held |
| `$60-$6F` | the colour bar `0`-`7` |
| `$D0-$D3` | the round button sprite |
| `$DA-$FF` | the AARONIX sprite animation (two sprites counting `$DA-$EC` and `$ED-$FF`) |

How they were found: the test app ran on the OneBus model while every button was pressed on both pads, A and B were
tapped fast, the sound test stepped, the sprite animation looped, and the RAM-flag and VRAM error screens were forced by
patching the compares. Every tile that reached the screen was recorded, then the code was read for what it can write
(the press counts can show any digit, so `$00-$09` are all kept). On the stripped image the test app gives the same
picture as on the original: 178 screenshots compared in each of the normal run and the two forced error runs.

## Street Fighter 2010 tiles in the menu backgrounds

841 background tiles are byte-for-byte tiles of Street Fighter 2010's CHR, all from its 2 KiB page at CHR
0x1E000-0x1E7FF (the starfield, planets and star burst). They are blanked with `$00` (`SF2010_TILES` in `tools/strip_rom.py`):

| Where | Tiles |
|---|---|
| every Chinese list page (0x00000 + page x 0x1000, 40 pages) | `$01`, `$1D`, `$32-$3F` (640 in all) |
| the spare copy in the Chinese sprite page (0x28000) | `$41-$6D`, `$72-$75` (49) |
| the English list background (0x62000) | `$41-$71` (49) |
| the language-select background (0x67000) | `$01-$67` (103) |

The space pictures are made of these tiles, so the three screens are now black there (a `$00` tile is the backdrop
colour; the previous version filled them with `$FF`, colour 3, which showed white and orange blocks). The text, logo,
cursor and menus are unchanged: `roms/sf2010_removed_before_after.png` shows the three screens before and after. The fragment was searched at every byte offset, also
flipped and with other colours. The only other equal tiles are one-colour solid tiles (the test app's colour bar),
which every game has; the flipped / recoloured matches were 1-8 pixel lines and Chinese glyph strokes. Kept.

## English menu only (`--english-menu`)

Starting from the stripped image, these are also filled with `$FF`:

| File range | Contents |
|---|---|
| 0x00000-0x28FFF | Chinese menu CHR (40 list pages, the sprite page) |
| 0x30000-0x3FFFF | Chinese menu banks `$18-$1F` (data, code, its vectors) |
| 0x67000-0x67FFF | language-select CHR |

Kept inside those: 0x3E34A-0x3F4B1, the Chinese menu's sound driver with its song and effects, which the 400-in-1 ROM
builder copies for the English list. The power-on code is patched at CPU `$FF89` (file 0x7FF89, `A2 34 8E 07 41` ->
`4C 7D FB`, JMP `$FB7D`), so the image boots straight into the English list without the language select. The A+B test
program is still there.

Checked on the OneBus model: booting into the English list, paging through all 40 pages and starting a game give the same
frames as the stripped image with the same patch; nothing it shows or reads was removed; the A+B test program is
unchanged. (Starting a game reads that game's reset vector, which lies beyond these 512 KiB; the model wraps the read to
0x3FFFC. On the cartridge it reads the game's own flash.) Not run on hardware.

## Content audit (`make strip-audit`)

`tools/strip_checks/audit.py` checks both images (13 checks, all pass):

* **Capcom sound bank.** Bank `$1C` (0x38000-0x39FFF) is all `$FF`. The engine's entry (`JMP $806C` / `JMP $803A`)
  occurs nowhere, and no 16-byte piece of the dump's bank `$1C` occurs anywhere. No code reads or jumps into bank `$1C`
  (checked on the OneBus model over all 40 Chinese pages). The Chinese menu's NMI still selects it at `$8000`
  (`lda #$3C / sta $4107` at `$FAD2`, then `jsr sound_tick`, the menu's own driver in bank `$1F`), as does its sound
  init; in the stripped image that maps `$FF`s and nothing reads them. It is kept because `music/menu_music.py` puts
  new Chinese-menu songs in that bank and relies on this mapping. The English-menu-only image has no Chinese code at all.
* **Street Fighter 2010** (with `SF2010=` its CHR, not shipped). Every 8x8 tile is looked up among all 16-byte windows
  of that CHR and among its tiles flipped and recoloured, counting only pictures (3+ colours, or 8+ pixels that are not
  one straight line). Left: the English font's digit `0` (a plain 7x7 zero, equal to Street Fighter 2010's `0` one row
  lower; the menu needs it), and in the stripped image one 9-pixel corner piece of a language-select tile that is never
  shown (`$A1`), equal only when recoloured.
* **Keep map.** No byte outside `tools/strip_rom.py`'s keep map is not `$FF`; in bank `$34` only the 95 tiles the test
  program shows remain; every byte equals the dump, `$FF`, `$00` (blanked tiles) or the boot patch.
* **Only two stripped images** in `roms/`: `…_stripped.bin` (language select, Chinese and English menus) and
  `…_stripped_EnglishMenu.bin`.

No program or graphics of another game is left. What is left that the menus never use is listed in `LEFTOVERS.md`:
text lists from other compilations (English names 401-500 of a 500-game list, the Chinese menu's hidden second ASCII
list), an unread record table, and older copies of the 400-in-1's own code and graphics.
