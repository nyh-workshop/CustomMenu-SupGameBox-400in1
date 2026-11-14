# roms/

The long version, with the evidence for every kept and removed area, the bank `$34` tile list and the checks: `STRIPPED.md`.

| file | size | SHA-1 | what |
|---|---|---|---|
| `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped.bin` | 524,288 | `acd69628491faa86c2517035fc0791023a4bc282` | the 512 KiB dump with everything the menus, the boot/TFT code and the A+B test program do not use filled with `$FF`, and with the Capcom sound bank and the Street Fighter 2010 background tiles removed: **the base `make rom` starts from**, and the default input of the music, wallpaper and game-list tools |
| `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped_EnglishMenu.bin` | 524,288 | `78f44eac8ab1f1ee408fc12a95a01c8ad1fe0dea` | the stripped image for the English list only: boots straight into it, everything of the Chinese menu and the language select removed (below). `make rom-EnglishMenu` builds the multicart on it |

**The full dump is no longer shipped.** `romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB.bin` (524,288 bytes,
SHA-1 `ecb67c77a8aa572bbe47d086c73a8557778fdd99`: the first 512 KiB of the flash with the opcode bits 4/5 swap undone)
is not needed for anything in the package: the source rebuilds compare with each block's `orig/` file (the original
bytes, pinned by SHA-1), and the tools read the stripped image. With your own copy, `DUMP=<file>` adds the full checks:
`make verify DUMP=…` (all 512 KiB), `make base-check DUMP=…`, `make strip-check DUMP=…`, `make strip-audit DUMP=…`,
and `make base DUMP=…` remakes the stripped image from it.

The stripped image (`tools/strip_rom.py`) keeps:

| kept | what |
|---|---|
| `0x00000-0x28FFF` | Chinese menu CHR |
| `0x2A000-0x2BFFF` | TFT bank `$15` (panel detection and set-up) |
| `0x30000-0x37FFF` | Chinese menu data, banks `$18-$1B` |
| `0x3A000-0x3FFFF` | Chinese menu banks `$1D-$1F`: code, the sound driver and song the builder copies, vectors |
| `0x62000-0x63FFF` | English menu CHR (bank `$31`) |
| `0x66000-0x67FFF` | boot stage 2 (bank `$33`) and the language-select CHR |
| 95 tiles of `0x68000-0x68FFF` | the A+B test program's CHR: only the tiles it can show (`TestApp/chr/bank34_used_tiles.png`) |
| `0x6A000-0x6FFFF` | language select and the A+B test program (code, data, the ROM-test source bank `$36`) |
| `0x78000-0x7FFFF` | the English menu, banks `$3C-$3F` |

Filled with `$FF` (about 223.7 KiB): 0x29000-0x29FFF, 0x2C000-0x2FFFF (GOBLET TOWER PRG), 0x38000-0x39FFF (bank `$1C`:
Capcom's sound engine with Mighty Final Fight's sound list and songs, never called), 0x40000-0x5FFFF (MARIO 3 CHR),
0x60000-0x61FFF, 0x64000-0x65FFF and 0x70000-0x77FFF (SPIDER MAN), and in bank `$34` the 417 tiles the test program
never shows (0x69000-0x69FFF and the gaps in 0x68000-0x68FFF).

**Street Fighter 2010 tiles removed.** 841 tiles of the menu backgrounds are byte-for-byte tiles of Street Fighter
2010's CHR (all from its 2 KiB page at CHR 0x1E000-0x1E7FF: the starfield, planets and the star burst). They are
blanked with `$00` (`SF2010_TILES` in `tools/strip_rom.py`):

| Where | Tiles |
|---|---|
| every Chinese list page (0x00000 + page × 0x1000, 40 pages) | `$01`, `$1D`, `$32-$3F` (16 per page, 640 in all) |
| the spare copy in the Chinese sprite page (0x28000) | `$41-$6D`, `$72-$75` (49) |
| the English list background (0x62000) | `$41-$71` (49) |
| the language-select background (0x67000) | `$01-$67` (103) |

The backgrounds are made of these tiles, so on the stripped image the three screens are black where the space picture was
(a `$00` tile is the backdrop colour, black; a `$FF` tile would be colour 3 of its palette, the white and orange blocks
of the previous version). A wallpaper of your own (`custom/wallpaper/english.png`) replaces
the English one completely. Still equal to a Street Fighter 2010 tile, and kept: only the solid one-colour tiles of the
test program's colour bar, which every game has. Matched by searching the fragment at every byte offset, also flipped and
with other colours; the flipped / recoloured matches were all 1-8 pixel lines and Chinese glyph strokes.

## English menu only (`make EnglishMenu`)

`tools/strip_rom.py --english-menu` starts from the stripped image and also removes, filling with `$FF`:

| removed | what |
|---|---|
| `0x00000-0x28FFF` | the Chinese menu CHR (40 list pages and the sprite page) |
| `0x30000-0x3FFFF` | the Chinese menu banks `$18-$1F` (data, code, its vectors) |
| `0x67000-0x67FFF` | the language-select CHR |

Kept inside those: `0x3E34A-0x3F4B1`, the Chinese menu's sound driver with its song and effects, because the builder copies
it for the English list (`rombuilder/english_sound.py`). The boot patch the builder makes anyway (CPU `$FF89`, file
0x7FF89: `A2 34 8E 07 41` -> `4C 7D FB`, JMP `$FB7D`) is applied, so the image starts in the English list without the
language select. Left: 64,444 bytes that are not `$FF` (62.9 KiB): English menu banks `$3C-$3F`, its CHR, boot stage 2,
the TFT bank, the A+B test program and that driver.

Checked on the OneBus model (`rombuilder/emu.py`): the English list, all 40 pages and a game start give the same frames as
the stripped image with the boot patch, nothing it shows or reads was removed, and the A+B test program is unchanged.
(The game start reads the reset vector of the game, which lies beyond these 512 KiB; the model wraps that read into
`0x3FFFC`. On the cartridge it is the game's own flash.)

The builder writes the English-list sound driver
and song into `0x70000-0x73FFF` (banks `$38/$39`).

```
make base-check [DUMP=…]         # make both images again (from your dump, else from the stripped image) and compare (identical)
make strip-check                 # boot all three images on the OneBus model and compare paths, sound and screens
make strip-audit [SF2010=f.bin]  # no Capcom bank, no Street Fighter 2010 tiles, nothing outside the keep map (STRIPPED.md)
make base DUMP=<512 KiB dump>    # make the stripped image from your own copy (opcode bits 4/5 already swapped back)
make rom-EnglishMenu             # the multicart on the English-menu-only image
make EnglishMenu [DUMP=...]      # make the English-menu-only image
make rom BASE_ROM=roms/romdump_sup400in1_10042024_201812_opcode_bits45_swap_512KiB_stripped_EnglishMenu.bin
```
